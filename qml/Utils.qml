import QtQuick

QtObject {
  function resetBenchmarking(mainPage, benchmarks) {
    benchmarks.forEach(benchmark => {
                         mainPage[benchmark] = ""
                       })
  }

  function runAllBenchmarks(comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const benchmarksToReset = ["seq1MRead", "seq1MReadIOPS", "seq1MReadGB", "seq1MWrite", "seq1MWriteIOPS", "seq1MWriteGB"]

    benchmarksToReset.forEach(benchmark => {
                                mainPage[benchmark] = ""
                              })

    mainPage.isBenchmarkingInProgress = true
    builder.seq1mq8t1_read(parseInt(comboGibCurrentText), comboLoopCurrentText,
                           benchmark, true)
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

  function runSeq1MRead(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const readBandwidth = values[1]
      const iops = values[2]

      mainPage.seq1MRead = readBandwidth
      mainPage.seq1MReadIOPS = iops
    }

    builder.seq1mq8t1_write(parseInt(comboGibCurrentText),
                            comboLoopCurrentText, benchmark, is_all)
  }

  function runSeq1MWrite(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const writeBandwidth = values[1]
      const iops = values[2]

      mainPage.seq1MWrite = writeBandwidth
      mainPage.seq1MWriteIOPS = iops
    }

    if (is_all) {
      mainPage.isBenchmarkingInProgress = true

      const benchmarksToReset = ["seq128KRead", "seq128KReadIOPS", "seq128KWrite", "seq128KWriteIOPS"]

      benchmarksToReset.forEach(benchmark => {
                                  mainPage[benchmark] = ""
                                })

      builder.seq128Kq8t1_read(parseInt(comboGibCurrentText),
                               comboLoopCurrentText, benchmark, is_all)
    } else {
      mainPage.isBenchmarkingInProgress = false
    }
  }

  function runSeq128KRead(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const readBandwidth = values[1]
      const iops = values[2]

      mainPage.seq128KRead = readBandwidth
      mainPage.seq128KReadIOPS = iops
    }

    builder.seq128Kq8t1_write(parseInt(comboGibCurrentText),
                              comboLoopCurrentText, benchmark, is_all)
  }

  function runSeq128KWrite(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const writeBandwidth = values[1]
      const iops = values[2]

      mainPage.seq128KWrite = writeBandwidth
      mainPage.seq128KWriteIOPS = iops
    }

    if (is_all) {
      mainPage.isBenchmarkingInProgress = true

      const benchmarksToReset = ["rand4KQ32T1Read", "rand4KQ32T1ReadIOPS", "rand4KQ32T1Write", "rand4KQ32T1WriteIOPS"]

      benchmarksToReset.forEach(benchmark => {
                                  mainPage[benchmark] = ""
                                })

      builder.rnd4kq32t1_read(parseInt(comboGibCurrentText),
                              comboLoopCurrentText, benchmark, is_all)
    } else {
      mainPage.isBenchmarkingInProgress = false
    }
  }

  function runRand4KQ32T1Read(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const readBandwidth = values[1]
      const iops = values[2]

      mainPage.rand4KQ32T1Read = readBandwidth
      mainPage.rand4KQ32T1ReadIOPS = iops
    }

    builder.rnd4kq32t1_write(parseInt(comboGibCurrentText),
                             comboLoopCurrentText, benchmark, is_all)
  }

  function runRand4KQ32T1Write(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const writeBandwidth = values[1]
      const iops = values[2]

      mainPage.rand4KQ32T1Write = writeBandwidth
      mainPage.rand4KQ32T1WriteIOPS = iops
    }

    if (is_all) {
      mainPage.isBenchmarkingInProgress = true

      const benchmarksToReset = ["rand4KQ1T1Read", "rand4KQ1T1ReadIOPS", "rand4KQ1T1Write", "rand4KQ1T1WriteIOPS"]

      benchmarksToReset.forEach(benchmark => {
                                  mainPage[benchmark] = ""
                                })

      builder.rnd4kq1t1_read(parseInt(comboGibCurrentText),
                             comboLoopCurrentText, benchmark, is_all)
    } else {
      mainPage.isBenchmarkingInProgress = false
    }
  }

  function runRand4KQ1T1Read(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    const values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)

    if (values) {
      const readBandwidth = values[1]
      const iops = values[2]

      mainPage.rand4KQ1T1Read = readBandwidth
      mainPage.rand4KQ1T1ReadIOPS = iops
    }

    builder.rnd4kq1t1_write(parseInt(comboGibCurrentText),
                            comboLoopCurrentText, benchmark, is_all)
  }

  function runRand4KQ1T1Write(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
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
