import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
  id: window
  width: 1221
  height: 674
  visible: true
  color: "#F66785"
  title: qsTr("Kitsune Specs")

  Image {
    anchors.fill: parent
    source: "file:///home/draco/Downloads/pink.jpg"
  }

  flags: Qt.Window | Qt.WindowFixedSize

  property string read: "0.00"
  property string write: "0.00"
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

  Connections {
    target: benchmark

    function onSeqReadFinished(bandwidth) {
      window.read = bandwidth
      builder.sequential_write(combo.currentText, benchmark)
    }

    function onSeqWriteFinished(bandwidth) {
      isBenchmarkingInProgress = false
      window.write = bandwidth
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

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("ALL")
                    font.bold: true
                    font.pointSize: 20
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
                    text: qsTr("SEQ")
                    font.bold: true
                    font.pointSize: 20
                  }

                  onClicked: {
                    window.read = ""
                    window.write = ""
                    isBenchmarkingInProgress = true
                    builder.sequential_read(combo.currentText, benchmark)
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
                    text: qsTr(window.read)
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
                    text: qsTr(window.write)
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

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("SEQ1M<br>Q1T1")
                    font.bold: true
                    font.pointSize: 20
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
                    text: qsTr("7126.02")
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
                    text: qsTr("5238.12")
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

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("RND4K<br>Q32T16")
                    font.bold: true
                    font.pointSize: 20
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
                    text: qsTr("4194.95")
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
                    text: qsTr("4380.31")
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

                  Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    text: qsTr("RND4K<br>Q1T1")
                    font.bold: true
                    font.pointSize: 20
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
                    text: qsTr("91.04")
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
                    text: qsTr("225.37")
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
                text: qsTr("Samsung SSD 980 PRO 1TB / AMD Ryzen 9 5950X")
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
