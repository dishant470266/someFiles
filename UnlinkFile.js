var RNFS = require("react-native-fs");
const UnlinkFile = async (url) => {
  return new Promise(async (resolve, reject) => {
    try {
      RNFS.exists(url.toString()).then((result) => {
        console.log("result", result);
        if (result) {
          RNFS.unlink(url.toString())
            .then(() => {})
            .catch((err) => {
              console.log("errrr UnlinkFile", err.message);
            });
        }
      });
      resolve(true);
    } catch (err) {
      console.log("err exists ===>", err);
      resolve(err);
    }
  });
};
export { UnlinkFile };
