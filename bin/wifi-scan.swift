// Passive scan of nearby BSSes via CoreWLAN. Does NOT associate or change the
// current connection — it only takes the radio off-channel for a moment, so it
// works while you sit on a different network (or a phone hotspot).
//
//   swift wifi-scan.swift                 one scan, all networks
//   swift wifi-scan.swift ZIM             one scan, SSIDs containing "ZIM"
//   swift wifi-scan.swift ZIM 60          rescan every 60s until ctrl-c
//   swift wifi-scan.swift ZIM 60 out.tsv  ...and append to out.tsv
//
// MUST be run interpreted (`swift wifi-scan.swift`), not compiled: macOS gates
// SSID/BSSID behind Location Services, and a compiled binary is its own TCC
// identity with no grant, so it reports every SSID as <hidden>. The interpreter
// run inherits the terminal app's permission. That is also why the repeat loop
// lives in here rather than in a shell wrapper — one process, one grant.

import CoreWLAN
import Foundation

let args = CommandLine.arguments
let filter = args.count > 1 && args[1] != "-" ? args[1] : nil
let interval = args.count > 2 ? Double(args[2]) : nil
let outPath = args.count > 3 ? args[3] : nil

guard let iface = CWWiFiClient.shared().interface() else {
    FileHandle.standardError.write("no Wi-Fi interface\n".data(using: .utf8)!)
    exit(1)
}

let header = "time\tssid\tbssid\tchannel\tband\twidth\trssi\tnoise\tsnr\tsecurity"
var sink: FileHandle?
if let p = outPath {
    if !FileManager.default.fileExists(atPath: p) {
        FileManager.default.createFile(atPath: p, contents: (header + "\n").data(using: .utf8))
    }
    sink = FileHandle(forWritingAtPath: p)
    sink?.seekToEndOfFile()
} else {
    print(header)
}

let iso = ISO8601DateFormatter()
iso.timeZone = TimeZone.current
iso.formatOptions = [.withFullTime, .withColonSeparatorInTime]

func emit(_ line: String) {
    if let s = sink {
        s.write((line + "\n").data(using: .utf8)!)
        FileHandle.standardError.write((line + "\n").data(using: .utf8)!)
    } else {
        print(line)
    }
}

func scanOnce() {
    let nets: Set<CWNetwork>
    do {
        nets = try iface.scanForNetworks(withSSID: nil)
    } catch {
        emit("\(iso.string(from: Date()))\tSCAN-FAILED\t\(error)")
        return
    }

    let stamp = iso.string(from: Date())
    let rows = nets
        .filter { n in
            guard let f = filter else { return true }
            return (n.ssid ?? "").localizedCaseInsensitiveContains(f)
        }
        .sorted { $0.rssiValue > $1.rssiValue }

    if rows.isEmpty {
        // Worth a row of its own: an SSID vanishing from the scan is exactly
        // what a DFS radar event or an AP reboot looks like from the outside.
        emit("\(stamp)\tNONE-FOUND\t-\t-\t-\t-\t-\t-\t-\t-")
        return
    }

    for n in rows {
        let ch = n.wlanChannel
        let band: String
        switch ch?.channelBand {
        case .band2GHz: band = "2.4GHz"
        case .band5GHz: band = "5GHz"
        default: band = "?"
        }
        let width: String
        switch ch?.channelWidth {
        case .width20MHz: width = "20"
        case .width40MHz: width = "40"
        case .width80MHz: width = "80"
        case .width160MHz: width = "160"
        default: width = "?"
        }
        // A DFS channel must be vacated the instant the AP thinks it sees
        // radar — the usual cause of an AP disappearing mid-session.
        let chNum = ch?.channelNumber ?? 0
        let dfs = (chNum >= 52 && chNum <= 144) ? "-DFS" : ""
        let security =
            n.supportsSecurity(.none) ? "open"
            : n.supportsSecurity(.wpa3Personal) ? "WPA3"
            : n.supportsSecurity(.wpa2Personal) ? "WPA2"
            : n.supportsSecurity(.wpaPersonal) ? "WPA"
            : n.supportsSecurity(.wpa2Enterprise) ? "WPA2-Ent" : "?"

        emit([
            stamp,
            n.ssid ?? "<hidden>",
            n.bssid ?? "<no-perm>",
            "\(chNum)\(dfs)",
            band, width,
            "\(n.rssiValue)", "\(n.noiseMeasurement)", "\(n.rssiValue - n.noiseMeasurement)",
            security,
        ].joined(separator: "\t"))
    }
}

if let iv = interval {
    FileHandle.standardError.write(
        "scanning every \(Int(iv))s\(outPath.map { " -> \($0)" } ?? "") — ctrl-c to stop\n"
            .data(using: .utf8)!)
    while true {
        scanOnce()
        Thread.sleep(forTimeInterval: iv)
    }
} else {
    scanOnce()
}
