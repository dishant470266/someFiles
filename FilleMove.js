var RNFS = require("react-native-fs");
export const FileMove = async (file, order_id) => {
  return new Promise(async (resolve, reject) => {
    try {
      var savedFile = {
        newUrl: null,
        name: null,
        success: false,
      };
      const lastIndexOf = file.lastIndexOf("/");
      var filename = file.substring(lastIndexOf + 1);
      savedFile["name"] = filename;
      savedFile["newUrl"] = file;
      let timestamp = new Date().getTime();
      let folderName ="myDIR";
      await RNFS.mkdir(`${RNFS.ExternalDirectoryPath}/${folderName}`);
      const newPath = `${RNFS.ExternalDirectoryPath}/${folderName}/${filename}`;
      console.log("file.toString()", file.toString());
      RNFS.copyFile(file.toString(), newPath)
        .then((success) => {
          let Newuri = "file://" + newPath;
          savedFile["name"] = filename;
          savedFile["newUrl"] = Newuri;
          savedFile["success"] = true;
          resolve(savedFile);
        })
        .catch((err) => {
          console.log("savelocation", err.message);
          reject("saved reject==>", err);
        });
    } catch (err) {
      console.log("err last", file);
      reject(err);
    }
  });
};
