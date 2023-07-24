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

    //This is test for past commit
    Menu {
      title: qsTr("File")

      Action {
        text: qsTr("Copy")
      }

      Action {
        text: qsTr("Save")
      }

      MenuSeparator {}

      Action {
        text: qsTr("Quit")
      }
    }

    Menu {
      title: qsTr("Settings")

      Action {
        text: qsTr("Standard Present")
      }

      Action {
        text: qsTr("NVMe SSD")
      }

      Action {
        text: qsTr("Queues & Threads")
      }
    }

    Menu {
      title: qsTr("Profile")

      Action {
        text: qsTr("Default")
      }

      Action {
        text: qsTr("Peak Performance")
      }

      Action {
        text: qsTr("Real World Performance")
      }

      Action {
        text: qsTr("DEMO")
      }
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
