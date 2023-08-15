import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Dialog {
  id: warningDialog
  anchors.centerIn: parent
  title: "User Warning"
  modal: true
  closePolicy: Popup.CloseOnEscape
  visible: true

  Column {
    spacing: 10
    width: parent.width

    RowLayout {
      spacing: 5

      Item {
        width: 24
        height: 24

        Image {
          source: "file:///home/draco/Downloads/warning(1).png"
          anchors.fill: parent
        }
      }

      Text {
        anchors.topMargin: 10
        text: "Warning: Continuous storage benchmarking may lead to decreased lifespan and performance of your storage device."
        wrapMode: Text.WordWrap
        font.family: "Montserrat"
        Layout.preferredWidth: warningDialog.width - 24
        font.bold: true
      }
    }

    Rectangle {
      height: 10
      width: 10
      color: "transparent"
    }

    Rectangle {
      x: 4
      width: warningDialog.width - 24
      height: textItem.implicitHeight
      color: "transparent"

      RowLayout {
        spacing: 5

        Item {
          width: 16
          height: 16

          Image {
            source: "file:///home/draco/Downloads/information-button(1).png"
            anchors.fill: parent
          }
        }

        Rectangle {
          x: 2
          width: warningDialog.width - 24
          height: textItem.implicitHeight
          color: "transparent"

          Text {
            anchors.fill: parent
            id: textItem
            text: "Please use this benchmarking tool responsibly and avoid excessive or prolonged benchmarking sessions on important storage devices."
            wrapMode: Text.WordWrap
            font.family: "Montserrat"
            Layout.preferredWidth: warningDialog.width - 24
            font.bold: true
          }
        }
      }
    }

    Rectangle {
      height: 10
      width: 10
      color: "transparent"
    }

    CheckBox {
      id: warningAcknowledge
      text: "I acknowledge and understand the risks."
      checked: false
      width: parent.width - 10
      font.family: "Montserrat"
    }

    RowLayout {
      spacing: 30
      anchors.horizontalCenter: parent.horizontalCenter

      Button {
        text: "Okay"
        onClicked: {
          if (warningAcknowledge.checked) {
            warningDialog.accept()
          }
        }
        font.family: "Montserrat"
        enabled: warningAcknowledge.checked
        font.bold: true
      }

      Button {
        text: "Ignore"
        onClicked: warningDialog.reject()
        font.bold: true
        font.family: "Montserrat"
      }
    }
  }

  onRejected: Qt.quit()
}
