# Translator Comment Policy

Translator comments are required for all user-facing strings. A PR introducing
new user-facing strings must also submit the accompanying translator comment.
To prevent this requirement from halting development, the PR author can specify
that they would like the introduction of the comment to be picked up in a follow-up PR.

## Formulating Translator Comments

Translator comments only apply to strings that are marked for translation.
For more information, see:
[Internationalization and Localization with Qt Quick](https://doc.qt.io/qt-5/qtquick-internationalization.html)

Below, lines 4 and 5 are examples of new user-facing strings marked for
translation without translator comments:

```c++
1.  OptionButton {
2.     ButtonGroup.group: group
3.     Layout.fillWidth: true
4.     text: qsTr("Only when on Wi-Fi")
5.     description: qsTr("Loads quickly when on wi-fi and pauses when on cellular data.")
6.  }
```

Translator comments are needed to provide a translator with the appropriate
context needed to aid them with translating a certain string.
The first step in formulating a translator comment is to think about what
information a translator needs to perform their job effectively.

**Necessary context is**:
- Where is this string shown?
  - e.g. Shown in the Create Wallet dialog, Shown in file menu options ...
- What action is associated with this string?
  - If the string is associated with a button, what is the outcome of pressing the button?
- Explain what the string is meant to convey
  - This is an explanatory text shown after X that aims to inform the user that ...

**Optional context is**:
- Alternatives to complicated/technical words
  - Some words may not have a direct one-to-one translation in certain languages.
    It is nice to provide a replacement for such a word. For example,
    some languages may not have a 1-1 translation for the word "subnet",
    an appropriate substitute for this word is "IP address".

The following applies this guideline to the example:

```c++
1.  OptionButton {
2.     ButtonGroup.group: group
3.     Layout.fillWidth: true
4.     //: Main text for button displayed when choosing the network mode the client will run in.
5.     //: Choosing this option means that the node will only sync when the device is connected to a wireless internet connection.
6.     text: qsTr("Only when on Wi-Fi")
7.     //: Explanatory text for button which allows user to set the client to only load when connected to wifi.
8.     //: This text intends to make it clear to the user that, under this mode, their node will not sync if connected to cellular data.
9.     //: If there is no clear translation for "cellular data", use the translation for "mobile data"
10.    description: qsTr("Loads quickly when on wi-fi and pauses when on cellular data.")
11.  }
```
