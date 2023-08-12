import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls 2.15

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
      spacing: 130

      Item {
        id: imageContainer
        width: 100
        height: 100

        Image {
          width: imageContainer.width
          height: imageContainer.height
          source: "file:////home/draco/Downloads/key-performance-indicator.png"
          anchors.centerIn: parent
          fillMode: Image.PreserveAspectFit
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
      anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        bottomMargin: 10
      }

      onClicked: aboutPagePopup.close()
    }
  }
}
