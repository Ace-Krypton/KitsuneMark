import QtQuick
import QtQuick.Window
import QtQuick.Dialogs
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
        text: qsTr("Copy")
      }

      Action {
        text: qsTr("Save")
        onTriggered: fileDialog.open()
      }

      MenuSeparator {}

      Action {
        text: qsTr("Quit")
        onTriggered: Qt.quit()
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
        text: qsTr("Queues and Threads")
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
        onTriggered: utils.changeWallpaper("Angel", mainPage)
      }

      Action {
        text: qsTr("Reki")
        onTriggered: utils.changeWallpaper("Reki", mainPage)
      }

      Action {
        text: qsTr("Aria")
        onTriggered: utils.changeWallpaper("Aria", mainPage)
      }

      Action {
        text: qsTr("Default")
        onTriggered: utils.changeWallpaper("Default", mainPage)
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

  FileDialog {
    id: fileDialog

    title: "Save Dialog"
    fileMode: FileDialog.SaveFile
    currentFolder: "file:///home/" + mainPage.system.getUser()

    onAccepted: {
      mainPage.system.writeToAFile(utils.properties(mainPage),
                                   fileDialog.currentFile)
    }
  }

  Utils {
    id: utils
  }

  MainPage {
    anchors.fill: parent
    id: mainPage
  }

  About {
    id: aboutPage
  }
}
