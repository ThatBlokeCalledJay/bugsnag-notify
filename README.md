# Bugsnag Notify
An Azure DevOps build and release task for notifying Bugsnag of your latest release. Available on the [Visual Studio Marketplace](https://marketplace.visualstudio.com/publishers/ThatBlokeCalledJay)

> **Important Notice:** Though [Bugsnag](https://www.bugsnag.com/) have kindly given me permission to use their logo, it is important to note that this extension is not an official Bugsnag product. If you are having any difficulties with this extension, please do not contact Bugsnag, contact me through the usual channels like Q&A and issues. Likewise... If you are having difficulties with Bugsnag, unrelated to this extension, please direct your questions to Bugsnag, and not me.

> Note: Bugsnag Notify has been designed to work with Azure DevOps pipelines.

Notify Bugsnag of your current release. This extension makes use of Bugsnag's [build api](https://bugsnagbuildapi.docs.apiary.io/).

![Bugsnag Notify Task Fields](https://thatblokecalledjay.blob.core.windows.net/public-images/bn/taskfields.png)

### Looking for help getting setup
Checkout the getting started wiki [rigt here](https://github.com/ThatBlokeCalledJay/bugsnag-notify/wiki/Getting-Started).

### Version Number Madness

Check out the following scenario:

1. Increment your app's current version.
2. Apply new version number to FileVersion.
3. Apply new version number to AssemblyVersion.
4. Ensure .Net pack uses your new version number when generating new packages.
5. Make sure all new bugs that are sent to Bugsnag include the new version number.
6. Finally, notify Bugsnag of your latest release, and it's new version number.

If you find yourself in this scenario, [click here](https://thatblokecalledjay.com/blog/view/justanotherday/continuous-integration-and-version-number-madness-b95d40aaf761) to find out how my Azure DevOps extensions can be made to work together to automate this entire process.

### Looking for a way to auto increment your version numbers?
Why not check out my other extensions:  

**On GitHub**
- [ThatBlokeCalledJay](https://github.com/ThatBlokeCalledJay)
- [Auto App Version](https://github.com/ThatBlokeCalledJay/auto-app-version)
- [Bugsnag Auto Version](https://github.com/ThatBlokeCalledJay/bugsnag-auto-version)
- [Set Json Property](https://github.com/ThatBlokeCalledJay/set-json-property)

**On Visual Studio Marketplace**
- [ThatBlokeCalledJay](https://marketplace.visualstudio.com/publishers/ThatBlokeCalledJay)
- [Auto App Version](https://marketplace.visualstudio.com/items?itemName=ThatBlokeCalledJay.thatblokecalledjay-autoappversion)
- [Bugsnag Auto Version](#)
- [Set Json Property](https://marketplace.visualstudio.com/items?itemName=ThatBlokeCalledJay.thatblokecalledjay-setjsonproperty)