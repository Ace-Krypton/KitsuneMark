import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import CustomTypes 1.0
import QtQuick.Controls

Item {
  id: mainPage
  width: 1221
  height: 674

  property System system: System {}

  property string seq1MRead: "0.00"
  property string seq1MReadIOPS: "0.00"
  property string seq1MReadGB: "0.00"

  property string seq1MWrite: "0.00"
  property string seq1MWriteIOPS: "0.00"
  property string seq1MWriteGB: "0.00"

  property string seq128KRead: "0.00"
  property string seq128KReadIOPS: "0.00"
  property string seq128KReadGB: "0.00"

  property string seq128KWrite: "0.00"
  property string seq128KWriteIOPS: "0.00"
  property string seq128KWriteGB: "0.00"

  property string rand4KQ32T1Read: "0.00"
  property string rand4KQ32T1ReadIOPS: "0.00"
  property string rand4KQ32T1ReadGB: "0.00"

  property string rand4KQ32T1Write: "0.00"
  property string rand4KQ32T1WriteIOPS: "0.00"
  property string rand4KQ32T1WriteGB: "0.00"

  property string rand4KQ1T1Read: "0.00"
  property string rand4KQ1T1ReadIOPS: "0.00"
  property string rand4KQ1T1ReadGB: "0.00"

  property string rand4KQ1T1Write: "0.00"
  property string rand4KQ1T1WriteIOPS: "0.00"
  property string rand4KQ1T1WriteGB: "0.00"

  property string cpuName: system.extract_cpu()
  property string ssdName: system.extract_ssd()
  property string storage: system.extract_storage()

  property int themeHeight: mainPage.height

  property bool isBenchmarkingInProgress: false
  property bool isAngelOrAria: false
  property string currentWallpaper: "../img/default.jpg"

  function changeWallpaper(theme) {
    switch (theme) {
    case "Angel":
      currentWallpaper = "../img/angel.jpg"
      isAngelOrAria = true
      break
    case "Reki":
      currentWallpaper = "../img/reki.png"
      isAngelOrAria = false
      break
    case "Aria":
      currentWallpaper = "../img/aria.jpg"
      isAngelOrAria = true
      break
    case "Default":
      currentWallpaper = "../img/default.jpg"
      isAngelOrAria = false
      break
    }
  }

  function convertMBtoGB(speedInMBps, type) {
    if (speedInMBps === "")
      return ""
    const speedInGBps = speedInMBps / 1024

    switch (type) {
    case "seq1MRead":
      return seq1MReadGB = speedInGBps.toFixed(3)
    case "seq1MWrite":
      return seq1MWriteGB = speedInGBps.toFixed(3)
    case "seq128KRead":
      return seq128KReadGB = speedInGBps.toFixed(3)
    case "seq128KWrite":
      return seq128KWriteGB = speedInGBps.toFixed(3)
    case "rand4KQ32T1Read":
      return rand4KQ32T1ReadGB = speedInGBps.toFixed(3)
    case "rand4KQ32T1Write":
      return rand4KQ32T1WriteGB = speedInGBps.toFixed(3)
    case "rand4KQ1T1Read":
      return rand4KQ1T1ReadGB = speedInGBps.toFixed(3)
    case "rand4KQ1T1Write":
      return rand4KQ1T1WriteGB = speedInGBps.toFixed(3)
    }
  }

  function textChanger(type) {
    switch (comboMB.currentText) {
    case "MB/s":
      switch (type) {
      case "seq1MRead":
        return seq1MRead
      case "seq1MWrite":
        return seq1MWrite
      case "seq128KRead":
        return seq128KRead
      case "seq128KWrite":
        return seq128KWrite
      case "rand4KQ32T1Read":
        return rand4KQ32T1Read
      case "rand4KQ32T1Write":
        return rand4KQ32T1Write
      case "rand4KQ1T1Read":
        return rand4KQ1T1Read
      case "rand4KQ1T1Write":
        return rand4KQ1T1Write
      }
      break
    case "GB/s":
      switch (type) {
      case "seq1MRead":
        return seq1MReadGB
      case "seq1MWrite":
        return seq1MWriteGB
      case "seq128KRead":
        return convertMBtoGB(seq128KRead, "seq128KRead")
      case "seq128KWrite":
        return convertMBtoGB(seq128KWrite, "seq128KWrite")
      case "rand4KQ32T1Read":
        return convertMBtoGB(rand4KQ32T1Read, "rand4KQ32T1Read")
      case "rand4KQ32T1Write":
        return convertMBtoGB(rand4KQ32T1Write, "rand4KQ32T1Write")
      case "rand4KQ1T1Read":
        return convertMBtoGB(rand4KQ1T1Read, "rand4KQ1T1Read")
      case "rand4KQ1T1Write":
        return convertMBtoGB(rand4KQ1T1Write, "rand4KQ1T1Write")
      }
      break
    case "IOPS":
      switch (type) {
      case "seq1MRead":
        return seq1MReadIOPS
      case "seq1MWrite":
        return seq1MWriteIOPS
      case "seq128KRead":
        return seq128KReadIOPS
      case "seq128KWrite":
        return seq128KWriteIOPS
      case "rand4KQ32T1Read":
        return rand4KQ32T1ReadIOPS
      case "rand4KQ32T1Write":
        return rand4KQ32T1WriteIOPS
      case "rand4KQ1T1Read":
        return rand4KQ1T1ReadIOPS
      case "rand4KQ1T1Write":
        return rand4KQ1T1WriteIOPS
      }
      break
    }
  }

  function runAllBenchmarks() {
    seq1MRead = ""
    seq1MReadIOPS = ""
    seq1MReadGB = ""
    seq1MWrite = ""
    seq1MWriteIOPS = ""
    seq1MWriteGB = ""
    isBenchmarkingInProgress = true
    builder.seq1mq8t1_read(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                           combo.currentText, benchmark, true)
  }

  Connections {
    target: benchmark

    function onExitWithFailure(detect) {
      isBenchmarkingInProgress = false

      switch (detect) {
      case "SMREAD":
        seq1MRead = "0.00"
        seq1MReadIOPS = "0.00"
        seq1MReadGB = "0.00"
        seq1MWrite = "0.00"
        seq1MWriteIOPS = "0.00"
        seq1MWriteGB = "0.00"
        break
      case "SKREAD":
        seq128KRead = "0.00"
        seq128KReadIOPS = "0.00"
        seq128KReadGB = "0.00"
        seq128KWrite = "0.00"
        seq128KWriteIOPS = "0.00"
        seq128KWriteGB = "0.00"
        break
      case "RGREAD":
        rand4KQ32T1Read = "0.00"
        rand4KQ32T1ReadIOPS = "0.00"
        rand4KQ32T1ReadGB = "0.00"
        rand4KQ32T1Write = "0.00"
        rand4KQ32T1WriteIOPS = "0.00"
        rand4KQ32T1WriteGB = "0.00"
        break
      case "RLREAD":
        rand4KQ1T1Read = "0.00"
        rand4KQ1T1ReadIOPS = "0.00"
        rand4KQ1T1ReadGB = "0.00"
        rand4KQ1T1Write = "0.00"
        rand4KQ1T1WriteIOPS = "0.00"
        rand4KQ1T1WriteGB = "0.00"
        break
      }
    }

    function onSeq1MReadFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      mainPage.seq1MRead = readBandwidth
      mainPage.seq1MReadIOPS = iops
      builder.seq1mq8t1_write(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                              combo.currentText, benchmark, is_all)
    }

    function onSeq1MWriteFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      mainPage.seq1MWrite = readBandwidth
      mainPage.seq1MWriteIOPS = iops

      if (is_all) {
        isBenchmarkingInProgress = true
        seq128KRead = ""
        seq128KWrite = ""
        builder.seq128Kq8t1_read(parseInt(comboGiB.currentText.match(
                                            /\d+/)[0]), combo.currentText,
                                 benchmark, is_all)
      } else {
        isBenchmarkingInProgress = false
      }
    }

    function onSeq128KReadFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      mainPage.seq128KRead = readBandwidth
      mainPage.seq128KReadIOPS = iops
      builder.seq128Kq8t1_write(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                                combo.currentText, benchmark, is_all)
    }

    function onSeq128KWriteFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      mainPage.seq128KWrite = readBandwidth
      mainPage.seq128KWriteIOPS = iops

      if (is_all) {
        isBenchmarkingInProgress = true
        rand4KQ32T1Read = ""
        rand4KQ32T1Write = ""
        builder.rnd4kq32t1_read(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                                combo.currentText, benchmark, is_all)
      } else {
        isBenchmarkingInProgress = false
      }
    }

    function onRand4KQ32T1ReadFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      mainPage.rand4KQ32T1Read = readBandwidth
      mainPage.rand4KQ32T1ReadIOPS = iops
      builder.rnd4kq32t1_write(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                               combo.currentText, benchmark, is_all)
    }

    function onRand4KQ32T1WriteFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      mainPage.rand4KQ32T1Write = readBandwidth
      mainPage.rand4KQ32T1WriteIOPS = iops

      if (is_all) {
        isBenchmarkingInProgress = true
        rand4KQ1T1Read = ""
        rand4KQ1T1Write = ""
        builder.rnd4kq1t1_read(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                               combo.currentText, benchmark, is_all)
      } else {
        isBenchmarkingInProgress = false
      }
    }

    function onRand4KQ1T1ReadFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      mainPage.rand4KQ1T1Read = readBandwidth
      mainPage.rand4KQ1T1ReadIOPS = iops

      builder.rnd4kq1t1_write(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                              combo.currentText, benchmark, is_all)
    }

    function onRand4KQ1T1WriteFinished(bandwidth, is_all) {
      isBenchmarkingInProgress = false
      var values = bandwidth.match(/(\d+(?:\.\d*)?)\s*=\s*(\d+(?:\.\d*)?)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      mainPage.rand4KQ1T1Write = readBandwidth
      mainPage.rand4KQ1T1WriteIOPS = iops
    }
  }

  Rectangle {
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      anchors.fill: parent

      Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        states: [
          State {
            name: "angelOrAriaTrue"
            when: isAngelOrAria
            PropertyChanges {
              target: firstImage
              height: parent.height
              visible: true
            }
          },
          State {
            name: "angelOrAriaFalse"
            when: !isAngelOrAria
            PropertyChanges {
              target: secondImage
              anchors.fill: parent
              visible: true
            }
          }
        ]

        Image {
          id: firstImage
          source: currentWallpaper
          visible: false
        }

        Image {
          id: secondImage
          source: currentWallpaper
          visible: false
        }

        Rectangle {
          id: mainFrame
          x: 450
          y: 15
          color: "transparent"
          width: mainPage.width - 470
          height: mainPage.height - 50

          ColumnLayout {
            anchors.fill: parent
            spacing: 10

            RowLayout {
              Layout.fillWidth: true
              spacing: 10

              Rectangle {
                Layout.preferredWidth: mainFrame.width * 0.2
                height: 100
                radius: height / 2

                BusyIndicator {
                  width: 70
                  height: 70
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  anchors.centerIn: parent
                  visible: isBenchmarkingInProgress
                  running: isBenchmarkingInProgress
                }

                Button {
                  id: testAllButton
                  anchors.fill: parent
                  visible: !isBenchmarkingInProgress

                  signal benchmarkFinished(string bandwidth)

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("ALL")
                    font.bold: true
                    font.pointSize: 20
                    font.family: "Montserrat"
                  }

                  onClicked: {
                    runAllBenchmarks()
                  }
                }
              }

              ColumnLayout {
                Rectangle {
                  color: "transparent"
                  width: mainPage.width - 630
                  height: 46

                  RowLayout {
                    Rectangle {
                      border.color: "#ABABAB"
                      width: 50
                      height: 50

                      ComboBox {
                        id: combo
                        anchors.centerIn: parent
                        width: 50
                        height: 50
                        ToolTip.delay: 500
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Loop Count")
                        font.family: "Montserrat"
                        enabled: !isBenchmarkingInProgress

                        model: ListModel {
                          ListElement {
                            text: qsTr("1")
                          }
                          ListElement {
                            text: qsTr("2")
                          }
                          ListElement {
                            text: qsTr("3")
                          }
                          ListElement {
                            text: qsTr("4")
                          }
                          ListElement {
                            text: qsTr("5")
                          }
                          ListElement {
                            text: qsTr("6")
                          }
                          ListElement {
                            text: qsTr("7")
                          }
                          ListElement {
                            text: qsTr("8")
                          }
                          ListElement {
                            text: qsTr("9")
                          }
                        }

                        contentItem: Rectangle {
                          implicitWidth: combo.width
                          implicitHeight: 10
                          border.color: "#ABABAB"

                          Text {
                            text: combo.currentText
                            font.pointSize: 15
                            anchors.centerIn: parent
                            font.bold: true
                            font.family: "Montserrat"
                          }
                        }

                        indicator: Item {
                          width: 0
                          height: 0
                        }
                      }
                    }

                    Rectangle {
                      border.color: "#ABABAB"
                      width: 110
                      height: 50

                      ComboBox {
                        id: comboGiB
                        anchors.centerIn: parent
                        width: 110
                        height: 50
                        ToolTip.delay: 500
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Size")
                        font.family: "Montserrat"
                        enabled: !isBenchmarkingInProgress

                        model: ListModel {
                          ListElement {
                            text: qsTr("1 GiB")
                          }
                          ListElement {
                            text: qsTr("2 GiB")
                          }
                          ListElement {
                            text: qsTr("4 GiB")
                          }
                          ListElement {
                            text: qsTr("8 GiB")
                          }
                          ListElement {
                            text: qsTr("16 GiB")
                          }
                          ListElement {
                            text: qsTr("32 GiB")
                          }
                          ListElement {
                            text: qsTr("64 GiB")
                          }
                        }

                        contentItem: Rectangle {
                          implicitWidth: comboGiB.width
                          implicitHeight: 10
                          border.color: "#ABABAB"

                          Text {
                            text: comboGiB.currentText
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 15
                            font.bold: true
                            font.family: "Montserrat"
                          }
                        }

                        indicator: Item {
                          width: 0
                          height: 0
                        }
                      }
                    }

                    Rectangle {
                      border.color: "#ABABAB"
                      width: 304
                      height: 50

                      ComboBox {
                        id: comboStorage
                        anchors.centerIn: parent
                        width: 304
                        height: 50
                        ToolTip.delay: 500
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Storage Info")
                        font.family: "Montserrat"
                        enabled: !isBenchmarkingInProgress

                        model: ListModel {
                          Component.onCompleted: {
                            append({
                                     "text": storage
                                   })
                          }
                        }

                        contentItem: Rectangle {
                          implicitWidth: comboStorage.width
                          implicitHeight: 10
                          border.color: "#ABABAB"

                          Text {
                            text: comboStorage.currentText
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 15
                            font.bold: true
                            font.family: "Montserrat"
                          }
                        }

                        indicator: Item {
                          width: 0
                          height: 0
                        }
                      }
                    }

                    Rectangle {
                      border.color: "#ABABAB"
                      width: 110
                      height: 50

                      ComboBox {
                        id: comboMB
                        anchors.centerIn: parent
                        width: 110
                        height: 50
                        ToolTip.delay: 500
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Converter")
                        font.family: "Montserrat"

                        model: ListModel {
                          ListElement {
                            text: qsTr("MB/s")
                          }
                          ListElement {
                            text: qsTr("GB/s")
                          }
                          ListElement {
                            text: qsTr("IOPS")
                          }
                        }

                        contentItem: Rectangle {
                          implicitWidth: comboMB.width
                          implicitHeight: 10
                          border.color: "#ABABAB"

                          Text {
                            text: comboMB.currentText
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 15
                            font.bold: true
                            font.family: "Montserrat"
                          }
                        }

                        indicator: Item {
                          width: 0
                          height: 0
                        }
                      }
                    }
                  }
                }

                Rectangle {
                  color: "transparent"
                  width: mainPage.width - 630
                  height: 46

                  RowLayout {
                    Layout.fillWidth: true

                    Rectangle {
                      color: "transparent"
                      width: seq1MReadID.width
                      height: 46

                      Text {
                        id: readMB
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                        text: qsTr("Read [" + comboMB.currentText + ']')
                        font.bold: true
                        font.pointSize: 20
                        font.family: "Montserrat"
                      }
                    }

                    Rectangle {
                      color: "transparent"
                      width: seq1MWriteID.width
                      height: 46

                      Text {
                        id: writeMB
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                        text: qsTr("Write [" + comboMB.currentText + ']')
                        font.bold: true
                        font.pointSize: 20
                        font.family: "Montserrat"
                      }
                    }
                  }
                }
              }
            }

            RowLayout {
              spacing: 10
              Layout.fillWidth: true

              Rectangle {
                Layout.preferredWidth: mainFrame.width * 0.2
                height: 100

                BusyIndicator {
                  width: 70
                  height: 70
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  anchors.centerIn: parent
                  visible: isBenchmarkingInProgress
                  running: isBenchmarkingInProgress
                }

                Button {
                  id: seq1M
                  anchors.fill: parent
                  visible: !isBenchmarkingInProgress
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  ToolTip.visible: hovered
                  ToolTip.text: qsTr(
                                  "Sequential 1MiB<br>Queues=8<br>Threads=1<br>("
                                  + comboMB.currentText) + ')'
                  font.family: "Montserrat"

                  signal benchmarkFinished(string bandwidth)

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("SEQ1M<br>Q8T1")
                    font.bold: true
                    font.pointSize: 20
                    font.family: "Montserrat"
                  }

                  onClicked: {
                    mainPage.seq1MRead = ""
                    mainPage.seq1MReadIOPS = ""
                    mainPage.seq1MReadGB = ""
                    mainPage.seq1MWrite = ""
                    mainPage.seq1MWriteIOPS = ""
                    mainPage.seq1MWriteGB = ""
                    isBenchmarkingInProgress = true
                    builder.seq1mq8t1_read(parseInt(comboGiB.currentText.match(
                                                      /\d+/)[0]),
                                           combo.currentText, benchmark, false)
                  }
                }
              }

              RowLayout {
                Layout.fillWidth: true

                Rectangle {
                  id: seq1MReadID
                  border.color: "#ABABAB"
                  width: (mainPage.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: mainPage.seq1MRead + " MB/s<br>" + convertMBtoGB(
                                                 mainPage.seq1MRead,
                                                 "seq1MRead") + " GB/s<br>"
                                               + seq1MReadIOPS + " IOPS"
                  ToolTip.visible: toolTipText ? read1MArea.containsMouse : false
                  ToolTip.text: toolTipText

                  MouseArea {
                    id: read1MArea
                    anchors.fill: parent
                    hoverEnabled: true
                  }

                  Text {
                    id: seq1MReadTextID
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: textChanger("seq1MRead")
                    font.bold: true
                    font.pointSize: 40
                    font.family: "Montserrat"
                  }
                }

                Rectangle {
                  id: seq1MWriteID
                  border.color: "#ABABAB"
                  width: (mainPage.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: mainPage.seq1MWrite + " MB/s<br>" + convertMBtoGB(
                                                 mainPage.seq1MWrite,
                                                 "seq1MWrite") + " GB/s<br>"
                                               + seq1MWriteIOPS + " IOPS"
                  ToolTip.visible: toolTipText ? write1MArea.containsMouse : false
                  ToolTip.text: toolTipText

                  MouseArea {
                    id: write1MArea
                    anchors.fill: parent
                    hoverEnabled: true
                  }

                  Text {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: textChanger("seq1MWrite")
                    font.bold: true
                    font.pointSize: 40
                    font.family: "Montserrat"
                  }
                }
              }
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: 10

              Rectangle {
                Layout.preferredWidth: mainFrame.width * 0.2
                height: 100

                BusyIndicator {
                  width: 70
                  height: 70
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  anchors.centerIn: parent
                  visible: isBenchmarkingInProgress
                  running: isBenchmarkingInProgress
                }

                Button {
                  id: seq1MT1
                  anchors.fill: parent
                  visible: !isBenchmarkingInProgress
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  ToolTip.visible: hovered
                  ToolTip.text: qsTr(
                                  "Sequential 128K<br>Queues=8<br>Threads=1<br>("
                                  + comboMB.currentText) + ')'

                  signal benchmarkFinished(string bandwidth)

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("SEQ128K<br>Q8T1")
                    font.bold: true
                    font.pointSize: 20
                    font.family: "Montserrat"
                  }

                  onClicked: {
                    mainPage.seq128KRead = ""
                    mainPage.seq128KReadIOPS = ""
                    mainPage.seq128KReadGB = ""
                    mainPage.seq128KWrite = ""
                    mainPage.seq128KWriteIOPS = ""
                    mainPage.seq128KWriteGB = ""
                    isBenchmarkingInProgress = true
                    builder.seq128Kq8t1_read(
                          parseInt(comboGiB.currentText.match(/\d+/)[0]),
                          combo.currentText, benchmark, false)
                  }
                }
              }

              RowLayout {
                Layout.fillWidth: true

                Rectangle {
                  border.color: "#ABABAB"
                  width: (mainPage.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: mainPage.seq128KRead + " MB/s<br>" + convertMBtoGB(
                                                 mainPage.seq128KRead,
                                                 "seq128KRead") + " GB/s<br>"
                                               + seq128KReadIOPS + " IOPS"
                  ToolTip.visible: toolTipText ? read128KArea.containsMouse : false
                  ToolTip.text: toolTipText

                  MouseArea {
                    id: read128KArea
                    anchors.fill: parent
                    hoverEnabled: true
                  }

                  Text {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: textChanger("seq128KRead")
                    font.bold: true
                    font.pointSize: 40
                    font.family: "Montserrat"
                  }
                }

                Rectangle {
                  border.color: "#ABABAB"
                  width: (mainPage.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: mainPage.seq128KWrite + " MB/s<br>" + convertMBtoGB(
                                                 mainPage.seq128KWrite,
                                                 "seq128KWrite") + " GB/s<br>"
                                               + seq128KWriteIOPS + " IOPS"
                  ToolTip.visible: toolTipText ? write128KArea.containsMouse : false
                  ToolTip.text: toolTipText

                  MouseArea {
                    id: write128KArea
                    anchors.fill: parent
                    hoverEnabled: true
                  }

                  Text {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: textChanger("seq128KWrite")
                    font.bold: true
                    font.pointSize: 40
                    font.family: "Montserrat"
                  }
                }
              }
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: 10

              Rectangle {
                Layout.preferredWidth: mainFrame.width * 0.2
                height: 100

                BusyIndicator {
                  width: 70
                  height: 70
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  anchors.centerIn: parent
                  visible: isBenchmarkingInProgress
                  running: isBenchmarkingInProgress
                }

                Button {
                  id: rnd4K
                  anchors.fill: parent
                  visible: !isBenchmarkingInProgress
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  ToolTip.visible: hovered
                  ToolTip.text: qsTr(
                                  "Random 4KiB<br>Queues=32<br>Threads=1<br>(")
                                + comboMB.currentText + ')'

                  signal benchmarkFinished(string bandwidth)

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("RND4K<br>Q32T1")
                    font.bold: true
                    font.pointSize: 20
                    font.family: "Montserrat"
                  }

                  onClicked: {
                    mainPage.rand4KQ32T1Read = ""
                    mainPage.rand4KQ32T1ReadIOPS = ""
                    mainPage.rand4KQ32T1ReadGB = ""
                    mainPage.rand4KQ32T1Write = ""
                    mainPage.rand4KQ32T1WriteIOPS = ""
                    mainPage.rand4KQ32T1WriteGB = ""
                    isBenchmarkingInProgress = true
                    builder.rnd4kq32t1_read(parseInt(comboGiB.currentText.match(
                                                       /\d+/)[0]),
                                            combo.currentText, benchmark, false)
                  }
                }
              }

              RowLayout {
                Layout.fillWidth: true

                Rectangle {
                  border.color: "#ABABAB"
                  width: (mainPage.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: mainPage.rand4KQ32T1Read
                                               + " MB/s<br>" + convertMBtoGB(
                                                 mainPage.rand4KQ32T1Read,
                                                 "rand4KQ32T1Read") + " GB/s<br>"
                                               + rand4KQ32T1ReadIOPS + " IOPS"
                  ToolTip.visible: toolTipText ? read4KQ32Area.containsMouse : false
                  ToolTip.text: toolTipText

                  MouseArea {
                    id: read4KQ32Area
                    anchors.fill: parent
                    hoverEnabled: true
                  }

                  Text {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: textChanger("rand4KQ32T1Read")
                    font.bold: true
                    font.pointSize: 40
                    font.family: "Montserrat"
                  }
                }

                Rectangle {
                  border.color: "#ABABAB"
                  width: (mainPage.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: mainPage.rand4KQ32T1Write
                                               + " MB/s<br>" + convertMBtoGB(
                                                 mainPage.rand4KQ32T1Write,
                                                 "rand4KQ32T1Write") + " GB/s<br>"
                                               + rand4KQ32T1WriteIOPS + " IOPS"
                  ToolTip.visible: toolTipText ? write4KQ32Area.containsMouse : false
                  ToolTip.text: toolTipText

                  MouseArea {
                    id: write4KQ32Area
                    anchors.fill: parent
                    hoverEnabled: true
                  }

                  Text {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: textChanger("rand4KQ32T1Write")
                    font.bold: true
                    font.pointSize: 40
                    font.family: "Montserrat"
                  }
                }
              }
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: 10

              Rectangle {
                Layout.preferredWidth: mainFrame.width * 0.2
                height: 100

                BusyIndicator {
                  width: 70
                  height: 70
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  anchors.centerIn: parent
                  visible: isBenchmarkingInProgress
                  running: isBenchmarkingInProgress
                }

                Button {
                  id: rnd4KQ1T1
                  anchors.fill: parent
                  visible: !isBenchmarkingInProgress
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  ToolTip.visible: hovered
                  ToolTip.text: qsTr(
                                  "Random 4KiB<br>Queues=1<br>Threads=1<br>(")
                                + comboMB.currentText + ')'

                  signal benchmarkFinished(string bandwidth)

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("RND4K<br>Q1T1")
                    font.bold: true
                    font.pointSize: 20
                    font.family: "Montserrat"
                  }

                  onClicked: {
                    mainPage.rand4KQ1T1Read = ""
                    mainPage.rand4KQ1T1ReadIOPS = ""
                    mainPage.rand4KQ1T1ReadGB = ""
                    mainPage.rand4KQ1T1Write = ""
                    mainPage.rand4KQ1T1WriteIOPS = ""
                    mainPage.rand4KQ1T1WriteGB = ""
                    isBenchmarkingInProgress = true
                    builder.rnd4kq1t1_read(parseInt(comboGiB.currentText.match(
                                                      /\d+/)[0]),
                                           combo.currentText, benchmark, false)
                  }
                }
              }

              RowLayout {
                Layout.fillWidth: true

                Rectangle {
                  border.color: "#ABABAB"
                  width: (mainPage.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: mainPage.rand4KQ1T1Read
                                               + " MB/s<br>" + convertMBtoGB(
                                                 mainPage.rand4KQ1T1Read,
                                                 "rand4KQ1T1Read") + " GB/s<br>"
                                               + rand4KQ1T1ReadIOPS + " IOPS"

                  ToolTip.visible: toolTipText ? read4KQ1Area.containsMouse : false
                  ToolTip.text: toolTipText

                  MouseArea {
                    id: read4KQ1Area
                    anchors.fill: parent
                    hoverEnabled: true
                  }

                  Text {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: textChanger("rand4KQ1T1Read")
                    font.bold: true
                    font.pointSize: 40
                    font.family: "Montserrat"
                  }
                }

                Rectangle {
                  border.color: "#ABABAB"
                  width: (mainPage.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: mainPage.rand4KQ1T1Write
                                               + " MB/s<br>" + convertMBtoGB(
                                                 mainPage.rand4KQ1T1Write,
                                                 "rand4KQ1T1Write") + " GB/s<br>"
                                               + rand4KQ1T1WriteIOPS + " IOPS"
                  ToolTip.visible: toolTipText ? write4KQ1Area.containsMouse : false
                  ToolTip.text: toolTipText

                  MouseArea {
                    id: write4KQ1Area
                    anchors.fill: parent
                    hoverEnabled: true
                  }

                  Text {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    text: textChanger("rand4KQ1T1Write")
                    font.pointSize: 40
                    font.family: "Montserrat"
                  }
                }
              }
            }

            Rectangle {
              id: infoBarID
              Layout.fillWidth: true
              border.color: "#ABABAB"
              height: 74

              Text {
                anchors.fill: parent
                anchors.leftMargin: 10
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                text: qsTr(ssdName + ' / ' + cpuName)
                font.bold: true
                font.pointSize: 20
                font.family: "Montserrat"
              }
            }
          }
        }
      }
    }
  }
}
