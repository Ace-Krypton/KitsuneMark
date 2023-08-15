import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import CustomTypes 1.0
import QtQuick.Controls

Item {
  id: mainPage
  width: 1221
  height: 674

  property Utils utils: Utils {}
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

  Warning {
    width: 500
    height: 500
  }

  Connections {
    target: benchmark

    function onExitWithFailure(detect) {
      utils.handlingFailure(detect, mainPage)
    }

    function handleFinishedBenchmark(bandwidth, is_all, runFunction) {
      const gibText = comboGiB.currentText.match(/\d+/)[0]
      const comboText = combo.currentText
      runFunction(bandwidth, is_all, gibText, comboText, mainPage)
    }

    function onSeq1MReadFinished(bandwidth, is_all) {
      handleFinishedBenchmark(bandwidth, is_all, utils.runSeq1MRead)
    }

    function onSeq1MWriteFinished(bandwidth, is_all) {
      handleFinishedBenchmark(bandwidth, is_all, utils.runSeq1MWrite)
    }

    function onSeq128KReadFinished(bandwidth, is_all) {
      handleFinishedBenchmark(bandwidth, is_all, utils.runSeq128KRead)
    }

    function onSeq128KWriteFinished(bandwidth, is_all) {
      handleFinishedBenchmark(bandwidth, is_all, utils.runSeq128KWrite)
    }

    function onRand4KQ32T1ReadFinished(bandwidth, is_all) {
      handleFinishedBenchmark(bandwidth, is_all, utils.runRand4KQ32T1Read)
    }

    function onRand4KQ32T1WriteFinished(bandwidth, is_all) {
      handleFinishedBenchmark(bandwidth, is_all, utils.runRand4KQ32T1Write)
    }

    function onRand4KQ1T1ReadFinished(bandwidth, is_all) {
      handleFinishedBenchmark(bandwidth, is_all, utils.runRand4KQ1T1Read)
    }

    function onRand4KQ1T1WriteFinished(bandwidth, is_all) {
      handleFinishedBenchmark(bandwidth, is_all, utils.runRand4KQ1T1Write)
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
                    utils.runAllBenchmarks(comboGiB.currentText.match(
                                             /\d+/)[0],
                                           combo.currentText, mainPage)
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
                    utils.resetBenchmarking(
                          mainPage,
                          ["seq1MRead", "seq1MReadIOPS", "seq1MReadGB", "seq1MWrite", "seq1MWriteIOPS", "seq1MWriteGB"])

                    isBenchmarkingInProgress = true
                    const gibText = comboGiB.currentText.match(/\d+/)[0]
                    const comboText = combo.currentText
                    builder.seq1mq8t1_read(parseInt(gibText), comboText,
                                           benchmark, false)
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
                  property string toolTipText: mainPage.seq1MRead + " MB/s<br>"
                                               + utils.convertMBtoGB(
                                                 mainPage.seq1MRead,
                                                 "seq1MRead",
                                                 mainPage) + " GB/s<br>" + seq1MReadIOPS + " IOPS"
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
                    text: utils.textChanger("seq1MRead", mainPage,
                                            comboMB.currentText)
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
                  property string toolTipText: mainPage.seq1MWrite + " MB/s<br>"
                                               + utils.convertMBtoGB(
                                                 mainPage.seq1MWrite,
                                                 "seq1MWrite",
                                                 mainPage) + " GB/s<br>" + seq1MWriteIOPS + " IOPS"
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
                    text: utils.textChanger("seq1MWrite", mainPage,
                                            comboMB.currentText)
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
                    utils.resetBenchmarking(
                          mainPage,
                          ["seq128KRead", "seq128KReadIOPS", "seq128KReadGB", "seq128KWrite", "seq128KWriteIOPS", "seq128KWriteGB"])

                    isBenchmarkingInProgress = true
                    const gibText = comboGiB.currentText.match(/\d+/)[0]
                    const comboText = combo.currentText
                    builder.seq128Kq8t1_read(parseInt(gibText), comboText,
                                             benchmark, false)
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
                  property string toolTipText: mainPage.seq128KRead + " MB/s<br>"
                                               + utils.convertMBtoGB(
                                                 mainPage.seq128KRead,
                                                 "seq128KRead",
                                                 mainPage) + " GB/s<br>" + seq128KReadIOPS + " IOPS"
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
                    text: utils.textChanger("seq128KRead", mainPage,
                                            comboMB.currentText)
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
                  property string toolTipText: mainPage.seq128KWrite + " MB/s<br>"
                                               + utils.convertMBtoGB(
                                                 mainPage.seq128KWrite,
                                                 "seq128KWrite",
                                                 mainPage) + " GB/s<br>"
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
                    text: utils.textChanger("seq128KWrite", mainPage,
                                            comboMB.currentText)
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
                    resetBenchmarking(
                          mainPage,
                          ["rand4KQ32T1Read", "rand4KQ32T1ReadIOPS", "rand4KQ32T1ReadGB", "rand4KQ32T1Write", "rand4KQ32T1WriteIOPS", "rand4KQ32T1WriteGB"])

                    isBenchmarkingInProgress = true
                    const gibText = comboGiB.currentText.match(/\d+/)[0]
                    const comboText = combo.currentText
                    builder.rnd4kq32t1_read(parseInt(gibText), comboText,
                                            benchmark, false)
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
                                               + " MB/s<br>" + utils.convertMBtoGB(
                                                 mainPage.rand4KQ32T1Read,
                                                 "rand4KQ32T1Read",
                                                 mainPage) + " GB/s<br>"
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
                    text: utils.textChanger("rand4KQ32T1Read", mainPage,
                                            comboMB.currentText)
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
                                               + " MB/s<br>" + utils.convertMBtoGB(
                                                 mainPage.rand4KQ32T1Write,
                                                 "rand4KQ32T1Write",
                                                 mainPage) + " GB/s<br>"
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
                    text: utils.textChanger("rand4KQ32T1Write", mainPage,
                                            comboMB.currentText)
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
                    resetBenchmarking(
                          mainPage,
                          ["rand4KQ1T1Read", "rand4KQ1T1ReadIOPS", "rand4KQ1T1ReadGB", "rand4KQ1T1Write", "rand4KQ1T1WriteIOPS", "rand4KQ1T1WriteGB"])

                    isBenchmarkingInProgress = true
                    const gibText = comboGiB.currentText.match(/\d+/)[0]
                    const comboText = combo.currentText
                    builder.rnd4kq1t1_read(parseInt(gibText), comboText,
                                           benchmark, false)
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
                                               + " MB/s<br>" + utils.convertMBtoGB(
                                                 mainPage.rand4KQ1T1Read,
                                                 "rand4KQ1T1Read",
                                                 mainPage) + " GB/s<br>"
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
                    text: utils.textChanger("rand4KQ1T1Read", mainPage,
                                            comboMB.currentText)
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
                                               + " MB/s<br>" + utils.convertMBtoGB(
                                                 mainPage.rand4KQ1T1Write,
                                                 "rand4KQ1T1Write",
                                                 mainPage) + " GB/s<br>"
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
                    text: utils.textChanger("rand4KQ1T1Write", mainPage,
                                            comboMB.currentText)
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
