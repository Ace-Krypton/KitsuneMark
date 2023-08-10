import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import CustomTypes 1.0
import QtQuick.Controls

ApplicationWindow {
  id: window
  width: 1221
  height: 674
  visible: true
  title: qsTr("Kitsune Mark")

  flags: Qt.Window | Qt.WindowFixedSize

  property System system: System {}

  property string seq1MRead: "0.00"
  property string seq1MReadIOPS: "0.00"

  property string seq1MWrite: "0.00"
  property string seq1MWriteIOPS: "0.00"

  property string seq128KRead: "0.00"
  property string seq128KReadIOPS: "0.00"

  property string seq128KWrite: "0.00"
  property string seq128KWriteIOPS: "0.00"

  property string rand4KQ32T1Read: "0.00"
  property string rand4KQ32T1ReadIOPS: "0.00"

  property string rand4KQ32T1Write: "0.00"
  property string rand4KQ32T1WriteIOPS: "0.00"

  property string rand4KQ1T1Read: "0.00"
  property string rand4KQ1T1ReadIOPS: "0.00"

  property string rand4KQ1T1Write: "0.00"
  property string rand4KQ1T1WriteIOPS: "0.00"

  property string cpuName: system.extract_cpu()
  property string ssdName: system.extract_ssd()
  property string storage: system.extract_storage()
  property int themeHeight: window.height
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

  function runAllBenchmarks() {
    seq1MRead = ""
    seq1MReadIOPS = ""
    seq1MWrite = ""
    seq1MWriteIOPS = ""
    isBenchmarkingInProgress = true
    builder.seq1mq8t1_read(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                           combo.currentText, benchmark, true)
  }

  Connections {
    target: benchmark

    function onSeq1MReadFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+)\s*=\s*(\d+)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      window.seq1MRead = readBandwidth
      window.seq1MReadIOPS = iops
      builder.seq1mq8t1_write(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                              combo.currentText, benchmark, is_all)
    }

    function onSeq1MWriteFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+)\s*=\s*(\d+)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      window.seq1MWrite = readBandwidth
      window.seq1MWriteIOPS = iops

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
      var values = bandwidth.match(/(\d+)\s*=\s*(\d+)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      window.seq128KRead = readBandwidth
      window.seq128KReadIOPS = iops
      builder.seq128Kq8t1_write(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                                combo.currentText, benchmark, is_all)
    }

    function onSeq128KWriteFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+)\s*=\s*(\d+)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      window.seq128KWrite = readBandwidth
      window.seq128KWriteIOPS = iops

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
      var values = bandwidth.match(/(\d+)\s*=\s*(\d+)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      window.rand4KQ32T1Read = readBandwidth
      window.rand4KQ32T1ReadIOPS = iops
      builder.rnd4kq32t1_write(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                               combo.currentText, benchmark, is_all)
    }

    function onRand4KQ32T1WriteFinished(bandwidth, is_all) {
      var values = bandwidth.match(/(\d+)\s*=\s*(\d+)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      window.rand4KQ32T1Write = readBandwidth
      window.rand4KQ32T1WriteIOPS = iops

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
      var values = bandwidth.match(/(\d+)\s*=\s*(\d+)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      window.rand4KQ1T1Read = readBandwidth
      window.rand4KQ1T1ReadIOPS = iops

      builder.rnd4kq1t1_write(parseInt(comboGiB.currentText.match(/\d+/)[0]),
                              combo.currentText, benchmark, is_all)
    }

    function onRand4KQ1T1WriteFinished(bandwidth, is_all) {
      isBenchmarkingInProgress = false
      var values = bandwidth.match(/(\d+)\s*=\s*(\d+)/)
      if (values) {
        var readBandwidth = values[1]
        var iops = values[2]
      }

      window.rand4KQ1T1Write = readBandwidth
      window.rand4KQ1T1WriteIOPS = iops
    }
  }

  menuBar: MenuBar {
    spacing: 15

    Menu {
      title: qsTr("File")

      Action {
        text: qsTr("New...")
      }

      Action {
        text: qsTr("Open...")
      }

      Action {
        text: qsTr("Save")
      }

      Action {
        text: qsTr("Save As...")
      }

      MenuSeparator {}

      Action {
        text: qsTr("Quit")
      }
    }

    Menu {
      title: qsTr("Settings")

      Action {
        text: qsTr("Cut")
      }

      Action {
        text: qsTr("Copy")
      }

      Action {
        text: qsTr("Paste")
      }
    }

    Menu {
      title: qsTr("Profile")
    }

    Menu {
      title: qsTr("Theme")

      Action {
        text: qsTr("Angel")
        onTriggered: changeWallpaper("Angel")
      }

      Action {
        text: qsTr("Reki")
        onTriggered: changeWallpaper("Reki")
      }

      Action {
        text: qsTr("Aria")
        onTriggered: changeWallpaper("Aria")
      }

      Action {
        text: qsTr("Default")
        onTriggered: changeWallpaper("Default")
      }
    }

    Menu {
      title: qsTr("Help")

      Action {
        text: qsTr("About")
      }

      Action {
        text: qsTr("Language")
      }
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
          width: window.width - 470
          height: window.height - 50

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
                  }

                  onClicked: {
                    runAllBenchmarks()
                  }
                }
              }

              ColumnLayout {
                Rectangle {
                  color: "transparent"
                  width: window.width - 630
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
                          ListElement {
                            text: qsTr("μs")
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
                  width: window.width - 630
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
                                  "Sequential 1MiB<br>Queues=8<br>Threads=1<br>(MB/s)")

                  signal benchmarkFinished(string bandwidth)

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("SEQ1M<br>Q8T1")
                    font.bold: true
                    font.pointSize: 20
                  }

                  onClicked: {
                    window.seq1MRead = ""
                    window.seq1MReadIOPS = ""
                    window.seq1MWrite = ""
                    window.seq1MWriteIOPS = ""
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
                  width: (window.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: window.seq1MRead + " MB/s<br>0.000 GB/s<br> "
                                               + seq1MReadIOPS + " IOPS<br>0.000 μs"
                  ToolTip.visible: toolTipText ? read1MArea.containsMouse : false
                  ToolTip.text: toolTipText

                  MouseArea {
                    id: read1MArea
                    anchors.fill: parent
                    hoverEnabled: true
                  }

                  Text {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr(window.seq1MRead)
                    font.bold: true
                    font.pointSize: 40
                  }
                }

                Rectangle {
                  id: seq1MWriteID
                  border.color: "#ABABAB"
                  width: (window.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: window.seq1MWrite + " MB/s<br>0.000 GB/s<br> "
                                               + seq1MWriteIOPS + " IOPS<br>0.000 μs"
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
                    text: qsTr(window.seq1MWrite)
                    font.bold: true
                    font.pointSize: 40
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
                                  "Sequential 128K<br>Queues=8<br>Threads=1<br>(MB/s)")

                  signal benchmarkFinished(string bandwidth)

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("SEQ128K<br>Q8T1")
                    font.bold: true
                    font.pointSize: 20
                  }

                  onClicked: {
                    window.seq128KRead = ""
                    window.seq128KReadIOPS = ""
                    window.seq128KWrite = ""
                    window.seq128KWriteIOPS = ""
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
                  width: (window.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: window.seq128KRead + " MB/s<br>0.000 GB/s<br> "
                                               + seq128KReadIOPS + " IOPS<br>0.000 μs"
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
                    text: qsTr(window.seq128KRead)
                    font.bold: true
                    font.pointSize: 40
                  }
                }

                Rectangle {
                  border.color: "#ABABAB"
                  width: (window.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: window.seq128KWrite + " MB/s<br>0.000 GB/s<br> "
                                               + seq128KWriteIOPS + " IOPS<br>0.000 μs"
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
                    text: qsTr(window.seq128KWrite)
                    font.bold: true
                    font.pointSize: 40
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
                                  "Random 4KiB<br>Queues=32<br>Threads=1<br>(MB/s)")

                  signal benchmarkFinished(string bandwidth)

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("RND4K<br>Q32T1")
                    font.bold: true
                    font.pointSize: 20
                  }

                  onClicked: {
                    window.rand4KQ32T1Read = ""
                    window.rand4KQ32T1ReadIOPS = ""
                    window.rand4KQ32T1Write = ""
                    window.rand4KQ32T1WriteIOPS = ""
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
                  width: (window.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: window.rand4KQ32T1Read + " MB/s<br>0.000 GB/s<br> "
                                               + rand4KQ32T1ReadIOPS + " IOPS<br>0.000 μs"
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
                    text: qsTr(window.rand4KQ32T1Read)
                    font.bold: true
                    font.pointSize: 40
                  }
                }

                Rectangle {
                  border.color: "#ABABAB"
                  width: (window.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: window.rand4KQ32T1Write + " MB/s<br>0.000 GB/s<br> "
                                               + rand4KQ32T1WriteIOPS + " IOPS<br>0.000 μs"
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
                    text: qsTr(window.rand4KQ32T1Write)
                    font.bold: true
                    font.pointSize: 40
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
                                  "Random 4KiB<br>Queues=1<br>Threads=1<br>(MB/s)")

                  signal benchmarkFinished(string bandwidth)

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("RND4K<br>Q1T1")
                    font.bold: true
                    font.pointSize: 20
                  }

                  onClicked: {
                    window.rand4KQ1T1Read = ""
                    window.rand4KQ1T1ReadIOPS = ""
                    window.rand4KQ1T1Write = ""
                    window.rand4KQ1T1WriteIOPS = ""
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
                  width: (window.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: window.rand4KQ1T1Read + " MB/s<br>0.000 GB/s<br> "
                                               + rand4KQ1T1ReadIOPS + " IOPS<br>0.000 μs"

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
                    text: qsTr(window.rand4KQ1T1Read)
                    font.bold: true
                    font.pointSize: 40
                  }
                }

                Rectangle {
                  border.color: "#ABABAB"
                  width: (window.width - 630) / 2 - 3
                  height: 100
                  ToolTip.delay: 500
                  ToolTip.timeout: 5000
                  property string toolTipText: window.rand4KQ1T1Write + " MB/s<br>0.000 GB/s<br> "
                                               + rand4KQ1T1WriteIOPS + " IOPS<br>0.000 μs"
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
                    text: qsTr(window.rand4KQ1T1Write)
                    font.pointSize: 40
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
              }
            }
          }
        }
      }
    }
  }
}
