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
  title: qsTr("Kitsune Specs")

  flags: Qt.Window | Qt.WindowFixedSize

  property System system: System {}
  property string seq1MRead: "0.00"
  property string seq1MWrite: "0.00"
  property string seq128KRead: "0.00"
  property string seq128KWrite: "0.00"
  property string rand4KQ32T1Read: "0.00"
  property string rand4KQ32T1Write: "0.00"
  property string rand4KQ1T1Read: "0.00"
  property string rand4KQ1T1Write: "0.00"
  property string cpuName: system.extract_cpu()
  property string ssdName: system.extract_ssd()
  property int themeHeight: window.height
  property bool isBenchmarkingInProgress: false
  property bool isAngelOrAria: false
  property string currentWallpaper: "file:///home/draco/Downloads/default.jpg"

  function changeWallpaper(theme) {
    switch (theme) {
    case "Angel":
      currentWallpaper = "file:///home/draco/Downloads/angel.jpg"
      isAngelOrAria = true
      break
    case "Reki":
      currentWallpaper = "file:///home/draco/Downloads/reki.png"
      isAngelOrAria = false
      break
    case "Aria":
      currentWallpaper = "file:///home/draco/Downloads/aria.jpg"
      isAngelOrAria = true
      break
    case "Default":
      currentWallpaper = "file:///home/draco/Downloads/default.jpg"
      isAngelOrAria = false
      break
    }
  }

  function runAllBenchmarks() {
    seq1MRead = ""
    seq1MWrite = ""
    isBenchmarkingInProgress = true
    builder.seq1mq8t1_read(combo.currentText, benchmark, true)
  }

  Connections {
    target: benchmark

    function onSeq1MReadFinished(bandwidth, is_all) {
      window.seq1MRead = bandwidth
      builder.seq1mq8t1_write(combo.currentText, benchmark, is_all)
    }

    function onSeq1MWriteFinished(bandwidth, is_all) {
      window.seq1MWrite = bandwidth
      if (is_all) {
        isBenchmarkingInProgress = true
        seq128KRead = ""
        seq128KWrite = ""
        builder.seq128Kq8t1_read(combo.currentText, benchmark, is_all)
      } else {
        isBenchmarkingInProgress = false
      }
    }

    function onSeq128KReadFinished(bandwidth, is_all) {
      window.seq128KRead = bandwidth
      builder.seq128Kq8t1_write(combo.currentText, benchmark, is_all)
    }

    function onSeq128KWriteFinished(bandwidth, is_all) {
      window.seq128KWrite = bandwidth
      if (is_all) {
        isBenchmarkingInProgress = true
        rand4KQ32T1Read = ""
        rand4KQ32T1Write = ""
        builder.rnd4kq32t1_read(combo.currentText, benchmark, is_all)
      } else {
        isBenchmarkingInProgress = false
      }
    }

    function onRand4KQ32T1ReadFinished(bandwidth, is_all) {
      window.rand4KQ32T1Read = bandwidth
      builder.rnd4kq32t1_write(combo.currentText, benchmark, is_all)
    }

    function onRand4KQ32T1WriteFinished(bandwidth, is_all) {
      window.rand4KQ32T1Write = bandwidth
      if (is_all) {
        isBenchmarkingInProgress = true
        rand4KQ1T1Read = ""
        rand4KQ1T1Write = ""
        builder.rnd4kq1t1_read(combo.currentText, benchmark, is_all)
      } else {
        isBenchmarkingInProgress = false
      }
    }

    function onRand4KQ1T1ReadFinished(bandwidth, is_all) {
      window.rand4KQ1T1Read = bandwidth
      builder.rnd4kq1t1_write(combo.currentText, benchmark, is_all)
    }

    function onRand4KQ1T1WriteFinished(bandwidth, is_all) {
      isBenchmarkingInProgress = false
      window.rand4KQ1T1Write = bandwidth
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
            spacing: 10

            RowLayout {
              spacing: 10

              Rectangle {
                width: 150
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
                        }

                        contentItem: Rectangle {
                          implicitWidth: combo.width
                          implicitHeight: 10
                          border.color: "#ABABAB"

                          Text {
                            text: combo.currentText
                            font.pointSize: 20
                            anchors.centerIn: parent
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
                      width: 134
                      height: 50

                      ComboBox {
                        id: comboGiB
                        anchors.centerIn: parent
                        width: 134
                        height: 50

                        model: ListModel {
                          ListElement {
                            text: qsTr("1 GiB")
                          }

                          ListElement {
                            text: qsTr("2 GiB")
                          }

                          ListElement {
                            text: qsTr("3 GiB")
                          }

                          ListElement {
                            text: qsTr("4 GiB")
                          }

                          ListElement {
                            text: qsTr("5 GiB")
                          }
                        }

                        contentItem: Rectangle {
                          implicitWidth: comboGiB.width
                          implicitHeight: 10
                          border.color: "#ABABAB"

                          Text {
                            text: comboGiB.currentText
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 20
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
                      width: 280
                      height: 50

                      ComboBox {
                        id: comboStorage
                        anchors.centerIn: parent
                        width: 280
                        height: 50

                        model: ListModel {
                          ListElement {
                            text: qsTr("S: 0% (0/931GiB)")
                          }

                          ListElement {
                            text: qsTr("D: 0% (0/486GiB)")
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
                            font.pointSize: 20
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

                        model: ListModel {
                          ListElement {
                            text: qsTr("MB/s")
                          }

                          ListElement {
                            text: qsTr("MiB/s")
                          }
                        }

                        contentItem: Rectangle {
                          implicitWidth: comboMB.width
                          implicitHeight: 10
                          border.color: "#ABABAB"

                          Text {
                            text: comboMB.currentText
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 20
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
                    Rectangle {
                      color: "transparent"
                      width: (window.width - 630) / 2 - 3
                      height: 46

                      Text {
                        id: readMB
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                        text: qsTr("Read (MB/s)")
                        font.bold: true
                        font.pointSize: 20
                      }
                    }

                    Rectangle {
                      color: "transparent"
                      width: (window.width - 630) / 2 - 3
                      height: 46

                      Text {
                        id: writeMB
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                        text: qsTr("Write (MB/s)")
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

              Rectangle {
                width: 150
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
                    window.seq1MWrite = ""
                    isBenchmarkingInProgress = true
                    builder.seq1mq8t1_read(combo.currentText, benchmark, false)
                  }
                }
              }

              RowLayout {
                Rectangle {
                  border.color: "#ABABAB"
                  width: (window.width - 630) / 2 - 3
                  height: 100

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
                  border.color: "#ABABAB"
                  width: (window.width - 630) / 2 - 3
                  height: 100

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
              spacing: 10

              Rectangle {
                width: 150
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
                    window.seq128KWrite = ""
                    isBenchmarkingInProgress = true
                    builder.seq128Kq8t1_read(combo.currentText,
                                             benchmark, false)
                  }
                }
              }

              RowLayout {
                Rectangle {
                  border.color: "#ABABAB"
                  width: (window.width - 630) / 2 - 3
                  height: 100

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
              spacing: 10

              Rectangle {
                width: 150
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
                    window.rand4KQ32T1Write = ""
                    isBenchmarkingInProgress = true
                    builder.rnd4kq32t1_read(combo.currentText, benchmark, false)
                  }
                }
              }

              RowLayout {
                Rectangle {
                  border.color: "#ABABAB"
                  width: (window.width - 630) / 2 - 3
                  height: 100

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
              spacing: 10

              Rectangle {
                width: 150
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
                    window.rand4KQ1T1Write = ""
                    isBenchmarkingInProgress = true
                    builder.rnd4kq1t1_read(combo.currentText, benchmark, false)
                  }
                }
              }

              RowLayout {
                Rectangle {
                  border.color: "#ABABAB"
                  width: (window.width - 630) / 2 - 3
                  height: 100

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
              border.color: "#ABABAB"
              width: window.width - 470
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
