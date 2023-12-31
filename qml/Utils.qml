import QtQuick

QtObject {
  function resetBenchmarking(mainPage, benchmarks) {
    benchmarks.forEach(benchmark => {
                         mainPage[benchmark] = ""
                       })
  }

  function properties(mainPage) {
    const data = [["* MB/s = 1,000,000 bytes/s [SATA/600 = 600,000,000 bytes/s]"], ["* KB = 1000 bytes, KiB = 1024 bytes"], [""], ["[Read]"], ["Sequential 1 MiB (Q=8, T=1):", `${mainPage.seq1MRead} MB/s`, `[${mainPage.seq1MReadIOPS} IOPS]`, `<${mainPage.seq1MReadGB} GB>`], ["Sequential 128 KiB (Q=32, T=1):", `${mainPage.seq128KRead} MB/s`, `[${mainPage.seq128KReadIOPS} IOPS]`, `<${mainPage.seq128KReadGB} GB>`], ["Random 4 KiB (Q=32, T=16):", `${mainPage.rand4KQ32T1Read} MB/s`, `[${mainPage.rand4KQ32T1ReadIOPS} IOPS]`, `<${mainPage.rand4KQ32T1ReadGB} GB>`], ["Random 4 KiB (Q=1, T=1):", `${mainPage.rand4KQ1T1Read} MB/s`, `[${mainPage.rand4KQ1T1ReadIOPS} IOPS]`, `<${mainPage.rand4KQ1T1ReadGB} GB>`], [""], ["[Write]"], ["Sequential 1 MiB (Q=8, T=1):", `${mainPage.seq1MWrite} MB/s`, `[${mainPage.seq1MWriteIOPS} IOPS]`, `<${mainPage.seq1MWriteGB} GB>`], ["Sequential 128 KiB (Q=32, T=1):", `${mainPage.seq128KWrite} MB/s`, `[${mainPage.seq128KWriteIOPS} IOPS]`, `<${mainPage.seq128KWriteGB} GB>`], ["Random 4 KiB (Q=32, T=16):", `${mainPage.rand4KQ32T1Write} MB/s`, `[${mainPage.rand4KQ32T1WriteIOPS} IOPS]`, `<${mainPage.rand4KQ32T1WriteGB} GB>`], ["Random 4 KiB (Q= 1, T=1):", `${mainPage.rand4KQ1T1Write} MB/s`, `[${mainPage.rand4KQ1T1WriteIOPS} IOPS]`, `<${mainPage.rand4KQ1T1WriteGB} GB>`]]

    const columnWidths = data.reduce((widths, row) => {
                                       return row.map((cell, index) => Math.max(
                                                        widths[index] || 0,
                                                        cell.length))
                                     }, [])

    const properties = data.map(row => {
                                  return row.map(
                                    (cell, index) => cell.padEnd(
                                      columnWidths[index])).join(" ")
                                }).join("\n")
    return properties
  }

  function runAllBenchmarks(comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const benchmarksToReset = ["seq1MRead", "seq1MReadIOPS", "seq1MReadGB", "seq1MWrite", "seq1MWriteIOPS", "seq1MWriteGB"]

    resetBenchmarking(mainPage, benchmarksToReset)

    mainPage.isBenchmarkingInProgress = true
    builder.sequential(parseInt(comboGibCurrentText), comboLoopCurrentText,
                       benchmark, true, "1M", "read")
  }

  function changeWallpaper(theme, mainPage) {
    const wallpaperMappings = {
      "Angel": {
        "wallpaper": "../img/angel.jpg",
        "isAngelOrAria": true
      },
      "Reki": {
        "wallpaper": "../img/reki.png",
        "isAngelOrAria": false
      },
      "Aria": {
        "wallpaper": "../img/aria.jpg",
        "isAngelOrAria": true
      },
      "Default": {
        "wallpaper": "../img/default.jpg",
        "isAngelOrAria": false
      }
    }

    const mapping = wallpaperMappings[theme]

    if (mapping) {
      mainPage.currentWallpaper = mapping.wallpaper
      mainPage.isAngelOrAria = mapping.isAngelOrAria
    }
  }

  function convertMBtoGB(speedInMBps, type, mainPage) {
    if (speedInMBps === "") {
      return ""
    }

    const speedInGBps = (speedInMBps / 1024).toFixed(3)

    const typeMappings = {
      "seq1MRead": "seq1MReadGB",
      "seq1MWrite": "seq1MWriteGB",
      "seq128KRead": "seq128KReadGB",
      "seq128KWrite": "seq128KWriteGB",
      "rand4KQ32T1Read": "rand4KQ32T1ReadGB",
      "rand4KQ32T1Write": "rand4KQ32T1WriteGB",
      "rand4KQ1T1Read": "rand4KQ1T1ReadGB",
      "rand4KQ1T1Write": "rand4KQ1T1WriteGB"
    }

    mainPage[typeMappings[type]] = speedInGBps
    return speedInGBps
  }

  function textChanger(type, mainPage, currentText) {
    const typeMappings = {
      "seq1MRead": {
        "MB/s": mainPage.seq1MRead,
        "GB/s": mainPage.seq1MReadGB,
        "IOPS": mainPage.seq1MReadIOPS
      },
      "seq1MWrite": {
        "MB/s": mainPage.seq1MWrite,
        "GB/s": mainPage.seq1MWriteGB,
        "IOPS": mainPage.seq1MWriteIOPS
      },
      "seq128KRead": {
        "MB/s": mainPage.seq128KRead,
        "GB/s": convertMBtoGB(mainPage.seq128KRead, "seq128KRead", mainPage),
        "IOPS": mainPage.seq128KReadIOPS
      },
      "seq128KWrite": {
        "MB/s": mainPage.seq128KWrite,
        "GB/s": convertMBtoGB(mainPage.seq128KWrite, "seq128KWrite", mainPage),
        "IOPS": mainPage.seq128KWriteIOPS
      },
      "rand4KQ32T1Read": {
        "MB/s": mainPage.rand4KQ32T1Read,
        "GB/s": convertMBtoGB(mainPage.rand4KQ32T1Read, "rand4KQ32T1Read",
                              mainPage),
        "IOPS": mainPage.rand4KQ32T1ReadIOPS
      },
      "rand4KQ32T1Write": {
        "MB/s": mainPage.rand4KQ32T1Write,
        "GB/s": convertMBtoGB(mainPage.rand4KQ32T1Write, "rand4KQ32T1Write",
                              mainPage),
        "IOPS": mainPage.rand4KQ32T1WriteIOPS
      },
      "rand4KQ1T1Read": {
        "MB/s": mainPage.rand4KQ1T1Read,
        "GB/s": convertMBtoGB(mainPage.rand4KQ1T1Read, "rand4KQ1T1Read",
                              mainPage),
        "IOPS": mainPage.rand4KQ1T1ReadIOPS
      },
      "rand4KQ1T1Write": {
        "MB/s": mainPage.rand4KQ1T1Write,
        "GB/s": convertMBtoGB(mainPage.rand4KQ1T1Write, "rand4KQ1T1Write",
                              mainPage),
        "IOPS": mainPage.rand4KQ1T1WriteIOPS
      }
    }

    return typeMappings[type][currentText]
  }

  function handlingFailure(detect, mainPage) {
    mainPage.isBenchmarkingInProgress = false

    const benchmarksMap = {
      "SMREAD": ["seq1MRead", "seq1MReadIOPS", "seq1MReadGB", "seq1MWrite", "seq1MWriteIOPS", "seq1MWriteGB"],
      "SKREAD": ["seq128KRead", "seq128KReadIOPS", "seq128KReadGB", "seq128KWrite", "seq128KWriteIOPS", "seq128KWriteGB"],
      "RGREAD": ["rand4KQ32T1Read", "rand4KQ32T1ReadIOPS", "rand4KQ32T1ReadGB", "rand4KQ32T1Write", "rand4KQ32T1WriteIOPS", "rand4KQ32T1WriteGB"],
      "RLREAD": ["rand4KQ1T1Read", "rand4KQ1T1ReadIOPS", "rand4KQ1T1ReadGB", "rand4KQ1T1Write", "rand4KQ1T1WriteIOPS", "rand4KQ1T1WriteGB"]
    }

    const benchmarksToReset = benchmarksMap[detect]

    if (benchmarksToReset) {
      benchmarksToReset.forEach(benchmark => {
                                  mainPage[benchmark] = "0.00"
                                })
    }
  }

  function runSeq1MRead(bandwidth, isAll, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const readBandwidth = values[1]
      const iops = values[2]

      mainPage.seq1MRead = readBandwidth
      mainPage.seq1MReadIOPS = iops
    }

    builder.sequential(parseInt(comboGibCurrentText), comboLoopCurrentText,
                       benchmark, isAll, "1M", "write")
  }

  function runSeq1MWrite(bandwidth, isAll, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const writeBandwidth = values[1]
      const iops = values[2]

      mainPage.seq1MWrite = writeBandwidth
      mainPage.seq1MWriteIOPS = iops
    }

    if (isAll) {
      mainPage.isBenchmarkingInProgress = true

      const benchmarksToReset = ["seq128KRead", "seq128KReadIOPS", "seq128KWrite", "seq128KWriteIOPS"]

      benchmarksToReset.forEach(benchmark => {
                                  mainPage[benchmark] = ""
                                })

      builder.sequential(parseInt(comboGibCurrentText), comboLoopCurrentText,
                         benchmark, isAll, "128K", "read")
    } else {
      mainPage.isBenchmarkingInProgress = false
    }
  }

  function runSeq128KRead(bandwidth, isAll, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const readBandwidth = values[1]
      const iops = values[2]

      mainPage.seq128KRead = readBandwidth
      mainPage.seq128KReadIOPS = iops
    }

    builder.sequential(parseInt(comboGibCurrentText), comboLoopCurrentText,
                       benchmark, isAll, "128K", "write")
  }

  function runSeq128KWrite(bandwidth, isAll, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const writeBandwidth = values[1]
      const iops = values[2]

      mainPage.seq128KWrite = writeBandwidth
      mainPage.seq128KWriteIOPS = iops
    }

    if (isAll) {
      mainPage.isBenchmarkingInProgress = true

      const benchmarksToReset = ["rand4KQ32T1Read", "rand4KQ32T1ReadIOPS", "rand4KQ32T1Write", "rand4KQ32T1WriteIOPS"]

      benchmarksToReset.forEach(benchmark => {
                                  mainPage[benchmark] = ""
                                })

      builder.random(parseInt(comboGibCurrentText), comboLoopCurrentText,
                     benchmark, isAll, "32", "read", "8")
    } else {
      mainPage.isBenchmarkingInProgress = false
    }
  }

  function runRand4KQ32T1Read(bandwidth, isAll, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const readBandwidth = values[1]
      const iops = values[2]

      mainPage.rand4KQ32T1Read = readBandwidth
      mainPage.rand4KQ32T1ReadIOPS = iops
    }

    builder.random(parseInt(comboGibCurrentText), comboLoopCurrentText,
                   benchmark, isAll, "32", "write", "8")
  }

  function runRand4KQ32T1Write(bandwidth, isAll, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const writeBandwidth = values[1]
      const iops = values[2]

      mainPage.rand4KQ32T1Write = writeBandwidth
      mainPage.rand4KQ32T1WriteIOPS = iops
    }

    if (isAll) {
      mainPage.isBenchmarkingInProgress = true

      const benchmarksToReset = ["rand4KQ1T1Read", "rand4KQ1T1ReadIOPS", "rand4KQ1T1Write", "rand4KQ1T1WriteIOPS"]

      benchmarksToReset.forEach(benchmark => {
                                  mainPage[benchmark] = ""
                                })

      builder.random(parseInt(comboGibCurrentText), comboLoopCurrentText,
                     benchmark, isAll, "1", "read", "256")
    } else {
      mainPage.isBenchmarkingInProgress = false
    }
  }

  function runRand4KQ1T1Read(bandwidth, isAll, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const readBandwidth = values[1]
      const iops = values[2]

      mainPage.rand4KQ1T1Read = readBandwidth
      mainPage.rand4KQ1T1ReadIOPS = iops
    }

    builder.random(parseInt(comboGibCurrentText), comboLoopCurrentText,
                   benchmark, isAll, "1", "write", "256")
  }

  function runRand4KQ1T1Write(bandwidth, isAll, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    mainPage.isBenchmarkingInProgress = false

    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const writeBandwidth = values[1]
      const iops = values[2]

      mainPage.rand4KQ1T1Write = writeBandwidth
      mainPage.rand4KQ1T1WriteIOPS = iops
    }
  }
}
