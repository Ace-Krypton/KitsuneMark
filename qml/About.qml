import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Popup {
  id: aboutPagePopup
  anchors.centerIn: parent
  width: 580
  height: 280
  modal: true
  visible: false
  closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

  contentItem: Rectangle {
    width: parent.width
    height: parent.height

    RowLayout {
      anchors.centerIn: parent
      spacing: 100

      Item {
        id: imageContainer
        width: 128
        height: 128

        Image {
          anchors.fill: parent
          source: "../img/hannya.png"
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Text {
          text: "Version: 3.1.3"
          font.bold: true
          font.pointSize: 10
          font.family: "Montserrat"
        }
        Text {
          text: "Flexible I/O Tester: fio-3.35"
          font.pointSize: 10
          font.family: "Montserrat"
        }
        Text {
          text: 'LICENSE: <html><style type="text/css"></style><a href="https://opensource.org/license/bsd-2-clause">BSD-2-Clause</a></html>'
          onLinkActivated: link => Qt.openUrlExternally(link)
          font.pointSize: 10
          font.family: "Montserrat"
        }
        Text {
          text: 'Author: <html><style type="text/css"></style><a href="https://ramizabbasov.com/">Ramiz Abbasov</a></html>'
          onLinkActivated: link => Qt.openUrlExternally(link)
          font.pointSize: 10
          font.family: "Montserrat"
        }
        Text {
          text: 'E-Mail: <html><style type="text/css"></style><a href="mailto:ramizna@code.edu.az">ramizna@code.edu.az</a></html>'
          onLinkActivated: link => Qt.openUrlExternally(link)
          font.pointSize: 10
          font.family: "Montserrat"
        }
      }
    }

    Button {
      text: qsTr("Close")
      font.family: "Montserrat"

      anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        bottomMargin: 10
      }

      onClicked: aboutPagePopup.close()
    }
  }
}
