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

    Text {
      wrapMode: Text.WordWrap
      width: parent.width - 10
      font.family: "Montserrat"
      color: "red"

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
          text: "Warning: Continuous storage benchmarking can lead to decreased lifespan and performance of your storage device."
          wrapMode: Text.WordWrap
        }
      }
    }

    Text {
      text: "Please use this benchmarking tool responsibly and avoid excessive or prolonged benchmarking sessions on important storage devices."
      wrapMode: Text.WordWrap
      width: parent.width - 10
      font.family: "Montserrat"
    }

    CheckBox {
      id: warningAcknowledge
      text: "I acknowledge and understand the risks."
      checked: false
      width: parent.width - 10
      font.family: "Montserrat"
    }

    RowLayout {
      spacing: 10
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
