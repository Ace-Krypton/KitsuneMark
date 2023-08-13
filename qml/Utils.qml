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
}
