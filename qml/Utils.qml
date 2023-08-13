import QtQuick 2.15

QtObject {
  function runAllBenchmarks(comboGibCurrentText, comboLoopCurrentText, mainPage) {
    mainPage.seq1MRead = ""
    mainPage.seq1MReadIOPS = ""
    mainPage.seq1MReadGB = ""
    mainPage.seq1MWrite = ""
    mainPage.seq1MWriteIOPS = ""
    mainPage.seq1MWriteGB = ""
    mainPage.isBenchmarkingInProgress = true
    builder.seq1mq8t1_read(parseInt(comboGibCurrentText), comboLoopCurrentText,
                           benchmark, true)
  }

  function changeWallpaper(theme, mainPage) {
    switch (theme) {
    case "Angel":
      mainPage.currentWallpaper = "../img/angel.jpg"
      mainPage.isAngelOrAria = true
      break
    case "Reki":
      mainPage.currentWallpaper = "../img/reki.png"
      mainPage.isAngelOrAria = false
      break
    case "Aria":
      mainPage.currentWallpaper = "../img/aria.jpg"
      mainPage.isAngelOrAria = true
      break
    case "Default":
      mainPage.currentWallpaper = "../img/default.jpg"
      mainPage.isAngelOrAria = false
      break
    }
  }

  function convertMBtoGB(speedInMBps, type, mainPage) {
    if (speedInMBps === "")
      return ""
    const speedInGBps = speedInMBps / 1024

    switch (type) {
    case "seq1MRead":
      return mainPage.seq1MReadGB = speedInGBps.toFixed(3)
    case "seq1MWrite":
      return mainPage.seq1MWriteGB = speedInGBps.toFixed(3)
    case "seq128KRead":
      return mainPage.seq128KReadGB = speedInGBps.toFixed(3)
    case "seq128KWrite":
      return mainPage.seq128KWriteGB = speedInGBps.toFixed(3)
    case "rand4KQ32T1Read":
      return mainPage.rand4KQ32T1ReadGB = speedInGBps.toFixed(3)
    case "rand4KQ32T1Write":
      return mainPage.rand4KQ32T1WriteGB = speedInGBps.toFixed(3)
    case "rand4KQ1T1Read":
      return mainPage.rand4KQ1T1ReadGB = speedInGBps.toFixed(3)
    case "rand4KQ1T1Write":
      return mainPage.rand4KQ1T1WriteGB = speedInGBps.toFixed(3)
    }
  }

  function textChanger(type, mainPage, currentText) {
    switch (currentText) {
    case "MB/s":
      switch (type) {
      case "seq1MRead":
        return mainPage.seq1MRead
      case "seq1MWrite":
        return mainPage.seq1MWrite
      case "seq128KRead":
        return mainPage.seq128KRead
      case "seq128KWrite":
        return mainPage.seq128KWrite
      case "rand4KQ32T1Read":
        return mainPage.rand4KQ32T1Read
      case "rand4KQ32T1Write":
        return mainPage.rand4KQ32T1Write
      case "rand4KQ1T1Read":
        return mainPage.rand4KQ1T1Read
      case "rand4KQ1T1Write":
        return mainPage.rand4KQ1T1Write
      }
      break
    case "GB/s":
      switch (type) {
      case "seq1MRead":
        return mainPage.seq1MReadGB
      case "seq1MWrite":
        return mainPage.seq1MWriteGB
      case "seq128KRead":
        return convertMBtoGB(mainPage.seq128KRead, "seq128KRead", mainPage)
      case "seq128KWrite":
        return convertMBtoGB(mainPage.seq128KWrite, "seq128KWrite", mainPage)
      case "rand4KQ32T1Read":
        return convertMBtoGB(mainPage.rand4KQ32T1Read,
                             "rand4KQ32T1Read", mainPage)
      case "rand4KQ32T1Write":
        return convertMBtoGB(mainPage.rand4KQ32T1Write,
                             "rand4KQ32T1Write", mainPage)
      case "rand4KQ1T1Read":
        return convertMBtoGB(mainPage.rand4KQ1T1Read,
                             "rand4KQ1T1Read", mainPage)
      case "rand4KQ1T1Write":
        return convertMBtoGB(mainPage.rand4KQ1T1Write,
                             "rand4KQ1T1Write", mainPage)
      }
      break
    case "IOPS":
      switch (type) {
      case "seq1MRead":
        return mainPage.seq1MReadIOPS
      case "seq1MWrite":
        return mainPage.seq1MWriteIOPS
      case "seq128KRead":
        return mainPage.seq128KReadIOPS
      case "seq128KWrite":
        return mainPage.seq128KWriteIOPS
      case "rand4KQ32T1Read":
        return mainPage.rand4KQ32T1ReadIOPS
      case "rand4KQ32T1Write":
        return mainPage.rand4KQ32T1WriteIOPS
      case "rand4KQ1T1Read":
        return mainPage.rand4KQ1T1ReadIOPS
      case "rand4KQ1T1Write":
        return mainPage.rand4KQ1T1WriteIOPS
      }
      break
    }
  }

  function handlingFailure(detect, mainPage) {
    mainPage.isBenchmarkingInProgress = false

    switch (detect) {
    case "SMREAD":
      mainPage.seq1MRead = "0.00"
      mainPage.seq1MReadIOPS = "0.00"
      mainPage.seq1MReadGB = "0.00"
      mainPage.seq1MWrite = "0.00"
      mainPage.seq1MWriteIOPS = "0.00"
      mainPage.seq1MWriteGB = "0.00"
      break
    case "SKREAD":
      mainPage.seq128KRead = "0.00"
      mainPage.seq128KReadIOPS = "0.00"
      mainPage.seq128KReadGB = "0.00"
      mainPage.seq128KWrite = "0.00"
      mainPage.seq128KWriteIOPS = "0.00"
      mainPage.seq128KWriteGB = "0.00"
      break
    case "RGREAD":
      mainPage.rand4KQ32T1Read = "0.00"
      mainPage.rand4KQ32T1ReadIOPS = "0.00"
      mainPage.rand4KQ32T1ReadGB = "0.00"
      mainPage.rand4KQ32T1Write = "0.00"
      mainPage.rand4KQ32T1WriteIOPS = "0.00"
      mainPage.rand4KQ32T1WriteGB = "0.00"
      break
    case "RLREAD":
      mainPage.rand4KQ1T1Read = "0.00"
      mainPage.rand4KQ1T1ReadIOPS = "0.00"
      mainPage.rand4KQ1T1ReadGB = "0.00"
      mainPage.rand4KQ1T1Write = "0.00"
      mainPage.rand4KQ1T1WriteIOPS = "0.00"
      mainPage.rand4KQ1T1WriteGB = "0.00"
      break
    }
  }

  function runSeq1MRead(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
    if (values) {
      var readBandwidth = values[1]
      var iops = values[2]
    }

    mainPage.seq1MRead = readBandwidth
    mainPage.seq1MReadIOPS = iops
    builder.seq1mq8t1_write(parseInt(comboGibCurrentText),
                            comboLoopCurrentText, benchmark, is_all)
  }

  function runSeq1MWrite(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
    if (values) {
      var readBandwidth = values[1]
      var iops = values[2]
    }

    mainPage.seq1MWrite = readBandwidth
    mainPage.seq1MWriteIOPS = iops

    if (is_all) {
      isBenchmarkingInProgress = true
      mainPage.seq128KRead = ""
      mainPage.seq128KReadIOPS = ""
      mainPage.seq128KWrite = ""
      mainPage.seq128KWriteIOPS = ""
      builder.seq128Kq8t1_read(parseInt(comboGibCurrentText),
                               comboLoopCurrentText, benchmark, is_all)
    } else {
      mainPage.isBenchmarkingInProgress = false
    }
  }

  function runSeq128KRead(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
    if (values) {
      var readBandwidth = values[1]
      var iops = values[2]
    }

    mainPage.seq128KRead = readBandwidth
    mainPage.seq128KReadIOPS = iops
    builder.seq128Kq8t1_write(parseInt(comboGibCurrentText),
                              comboLoopCurrentText, benchmark, is_all)
  }

  function runSeq128KWrite(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
    if (values) {
      var readBandwidth = values[1]
      var iops = values[2]
    }

    mainPage.seq128KWrite = readBandwidth
    mainPage.seq128KWriteIOPS = iops

    if (is_all) {
      mainPage.isBenchmarkingInProgress = true
      mainPage.rand4KQ32T1Read = ""
      mainPage.rand4KQ32T1ReadIOPS = ""
      mainPage.rand4KQ32T1Write = ""
      mainPage.rand4KQ32T1WriteIOPS = ""
      builder.rnd4kq32t1_read(parseInt(comboGibCurrentText),
                              comboLoopCurrentText, benchmark, is_all)
    } else {
      mainPage.isBenchmarkingInProgress = false
    }
  }

  function runRand4KQ32T1Read(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
    if (values) {
      var readBandwidth = values[1]
      var iops = values[2]
    }

    mainPage.rand4KQ32T1Read = readBandwidth
    mainPage.rand4KQ32T1ReadIOPS = iops
    builder.rnd4kq32t1_write(parseInt(comboGibCurrentText),
                             comboLoopCurrentText, benchmark, is_all)
  }

  function runRand4KQ32T1Write(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
    if (values) {
      var readBandwidth = values[1]
      var iops = values[2]
    }

    mainPage.rand4KQ32T1Write = readBandwidth
    mainPage.rand4KQ32T1WriteIOPS = iops

    if (is_all) {
      mainPage.isBenchmarkingInProgress = true
      mainPage.rand4KQ1T1Read = ""
      mainPage.rand4KQ1T1ReadIOPS = ""
      mainPage.rand4KQ1T1Write = ""
      mainPage.rand4KQ1T1WriteIOPS = ""
      builder.rnd4kq1t1_read(parseInt(comboGibCurrentText),
                             comboLoopCurrentText, benchmark, is_all)
    } else {
      mainPage.isBenchmarkingInProgress = false
    }
  }

  function runRand4KQ1T1Read(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
    if (values) {
      var readBandwidth = values[1]
      var iops = values[2]
    }

    mainPage.rand4KQ1T1Read = readBandwidth
    mainPage.rand4KQ1T1ReadIOPS = iops

    builder.rnd4kq1t1_write(parseInt(comboGibCurrentText),
                            comboLoopCurrentText, benchmark, is_all)
  }

  function runRand4KQ1T1Write(bandwidth, is_all, comboGibCurrentText, comboLoopCurrentText, mainPage) {
    mainPage.isBenchmarkingInProgress = false
    var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
    if (values) {
      var readBandwidth = values[1]
      var iops = values[2]
    }

    mainPage.rand4KQ1T1Write = readBandwidth
    mainPage.rand4KQ1T1WriteIOPS = iops
  }
}
