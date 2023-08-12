import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import CustomTypes 1.0
import QtQuick.Controls

ApplicationWindow {
  visible: true
  title: qsTr("Kitsune Mark")
  width: 1221
  height: 674

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
        onTriggered: mainPage.changeWallpaper("Angel")
      }

      Action {
        text: qsTr("Reki")
        onTriggered: mainPage.changeWallpaper("Reki")
      }

      Action {
        text: qsTr("Aria")
        onTriggered: mainPage.changeWallpaper("Aria")
      }

      Action {
        text: qsTr("Default")
        onTriggered: mainPage.changeWallpaper("Default")
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

  MainPage {
    id: mainPage
  }

  About {
    id: aboutPage
  }
}
