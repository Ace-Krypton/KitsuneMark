import QtQuick
import QtQuick.Window
import QtQuick.Controls

ApplicationWindow {
  visible: true
  title: qsTr("Kitsune Mark")
  width: 1221
  height: 674
  color: "white"

  flags: Qt.Window | Qt.WindowFixedSize

  menuBar: MenuBar {
    spacing: 15
    font.family: "Montserrat"

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
        onTriggered: funcUtils.changeWallpaper("Angel", mainPage)
      }

      Action {
        text: qsTr("Reki")
        onTriggered: funcUtils.changeWallpaper("Reki", mainPage)
      }

      Action {
        text: qsTr("Aria")
        onTriggered: funcUtils.changeWallpaper("Aria", mainPage)
      }

      Action {
        text: qsTr("Default")
        onTriggered: funcUtils.changeWallpaper("Default", mainPage)
      }
    }

    Menu {
      title: qsTr("Help")

      Action {
        text: qsTr("About")
        onTriggered: aboutPage.visible = true
      }

      Action {
        text: qsTr("Language")
      }
    }
  }

  Utils {
    id: funcUtils
  }

  MainPage {
    anchors.fill: parent
    id: mainPage
  }

  About {
    id: aboutPage
  }
}
