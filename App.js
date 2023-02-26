import {
  Image,
  ImageBackground,
  PermissionsAndroid,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React, {useEffect, useState} from 'react';
import * as ImagePicker from 'react-native-image-picker';
import {FileMove} from './functions/FilleMove';
import {UnlinkFile} from './functions/UnlinkFile';
const App = () => {
  const [imageArr, setImageArr] = useState([]);
  const clickImage = async () => {
    const options = {
      saveToPhotos: true,
      mediaType: 'photo',
      includeBase64: false,
      includeExtra: true,
    };
    const granted = await PermissionsAndroid.request(
      PermissionsAndroid.PERMISSIONS.CAMERA,
    );
    console.log('granted L : ', granted);

    if (granted == PermissionsAndroid.RESULTS.GRANTED) {
      ImagePicker.launchCamera(options, async res => {
        console.log('dqwfegr', res.assets[0].uri);
        let uri =
          Platform.OS === 'android'
            ? res?.assets[0]?.uri.replace('file:/', 'file:///')
            : res?.assets[0]?.uri.replace('file://', '');
        // setImageArr([...imageArr, res.assets[0]]);
        let fileMoveResult = await FileMove(uri);
        console.log('file res : ', fileMoveResult);
        if (fileMoveResult?.success) {
          let unlinkFile = await UnlinkFile(uri);
        }
        let obj = res.assets[0];
        obj.uri = fileMoveResult.newUrl;

        setImageArr([...imageArr, obj]);
      });
    }
  };
  const deleteFile=async(url,id)=>{
    let unlinkFile = await UnlinkFile(url);
    if(unlinkFile)
    {
      const arr=imageArr.filter(item=>{return item.id!==id})
      setImageArr(arr)
    }

  }

  return (
    <View
      style={{
        flex: 1,
        backgroundColor: '#fff',
        alignItems: 'center',
        justifyContent: 'center',
      }}>
      <View style={{flexDirection: 'row'}}>
        {imageArr.map((item, index) => (
          <View style={{margin: 5}} key={item.id.toString()}>
            <TouchableOpacity
              style={{position: 'absolute', zIndex: 1, top: 0, right: 0}}
              onPress={()=>deleteFile(item.uri,item.id)}
              >
              <Text style={{fontSize: 28}}>X</Text>
            </TouchableOpacity>
            <Image
              source={{
                uri: item.uri,
              }}
              style={styles.image}
              resizeMode="contain"
            />
          </View>
        ))}
      </View>
      <TouchableOpacity
        disabled={imageArr.length == 5}
        style={{
          borderWidth: 1,
          backgroundColor: imageArr.length == 5 ? 'grey' : 'red',
          padding: 10,
        }}
        onPress={clickImage}>
        <Text>open camera</Text>
      </TouchableOpacity>
    </View>
  );
};

export default App;

const styles = StyleSheet.create({
  image: {
    width: 100,
    height: 90,
    alignItems: 'center',
    borderWidth: 1,
    justifyContent: 'center',
  },
});
