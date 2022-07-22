import React, {useEffect, useState} from 'react';
import {
  Image,
  ImageBackground,
  Modal,
  View,
  Switch,
  Platform,
  TouchableOpacity,
  Text,
  ToastAndroid,
} from 'react-native';
import CheckBox from '@react-native-community/checkbox';
import ProfileBarScreen from './ProfileBarScreen';
import Icon from 'react-native-vector-icons/Octicons';
import Icon1 from 'react-native-vector-icons/MaterialCommunityIcons';
import styles from './styles';
import {Store} from '../../utilities/Storage';
import {useFocusEffect} from '@react-navigation/native';
import ChakraPetchText from '../../components/fontComponent/ChakraPetchText';
import {useDispatch, useSelector} from 'react-redux';
import {getAvatars, updateAvatar} from '../../store/avatar/actions';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {GAvatar} from '../../components/GameAvatar';
import LottieView from 'lottie-react-native';

// import AuthContext from '../../utilities/registerScreens/Auth/AuthContext';
var datafoundinstore = false;
const Profile = ({route}: any) => {
  // console.log(route,"pppppppppppppp");
  const {navigation} = route.params;

  const dispatch = useDispatch();

  const avatarList = useSelector(getAvatars);
  const avatar = useSelector(getAvatars);

  // const detail = React.useContext(AuthContext);
  const [modalVisible, setModalVisible] = useState(false);
  const [Notification, setNotification] = useState(false);
  const [userName, setUserName] = useState('');
  const [name, setName] = useState<any>('');
  const [mobile, setMobile] = useState<any>('');
  const [network, setNetwork] = useState(false);
  const [imgURL, setImgUrl] = useState('');
  const NotificationSwitch = () =>
    setNotification(previousState => !previousState);
  const NetworkSwitch = () => setNetwork(previousState => !previousState);
  const [homework, setHomeWork] = useState(false);

  const thumbColorOn = Platform.OS === 'android' ? '#0cd1e8' : '#f3f3f3';
  const thumbColorOff = Platform.OS === 'android' ? '#f04141' : '#f3f3f3';
  const trackColorOn = Platform.OS === 'android' ? '#98e7f0' : '#0cd1e8';
  const trackColorOff = Platform.OS === 'android' ? '#f3adad' : '#f04141';

  useFocusEffect(
    React.useCallback(() => {
      dispatch(updateAvatar());
      fun1();
      getUserInfo();
      nameEmail();
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []),
  );
  const getUserInfo = async () => {
    const {personal} = await Store.getData('userDetails');
    if (personal) {
      setName(personal.userName);
      setMobile(personal.usermobile);
      datafoundinstore = true;
    } else {
      var data: any = await AsyncStorage.getItem('userDetail');
      data = JSON.parse(data);
      //  console.log('daata',data);
      if (data.userName) {
        setName(data.userName);
        datafoundinstore = true;
      }

      setMobile(data.usermobile);
    }
    //  setDateGot(data.dateofbirth);
  };

  const nameEmail = async () => {
    const userName = await Store.getData('userName');
    const email = await Store.getData('email');

    console.log('userName', userName, email);
    if (!datafoundinstore) {
      setName(userName);
    }
    //  setEmail(email);
  };

  const fun1 = async () => {
    const data = await Store.getData('AvatarImg');
    setImgUrl(data);
  };
  const SaveUserDetails = async () => {
    // console.log('button pressed');

    const temp1 = await Store.getData('TempUserDetail');

    if (temp1.usermobile.length > 0 && temp1.usermobile.length < 10) {
      // console.log(temp1.usermobile.length);

      ToastAndroid.show('invalid contact', ToastAndroid.SHORT);
      return;
    }
    const temp2 = await Store.getData('TempFamilyDetails');

    const temp3 = await Store.getData('TempSchoolDetails');
    const ob = {personal: temp1, family: temp2, school: temp3};
    // console.log('personal info : ', temp1);
    // console.log('family info : ', temp2);
    // console.log('school info : ', temp3);
    await AsyncStorage.setItem('userDetails', JSON.stringify(ob));
    console.log('button pressed', ob);
    ToastAndroid.show('Details saved', ToastAndroid.SHORT);
    //  navigation.goBack();
  };

  return (
    <ImageBackground
      resizeMode="cover"
      source={require('../../../Assest/PageBG.jpg')}
      style={styles.bgroundImage}>
      <View style={styles.MainContainer}>
        <TouchableOpacity onPress={() => navigation.navigate('ProfileAvatar')}>
          {imgURL ? (
            <GAvatar imageStyle={styles.image} name={imgURL} />
          ) : (
            <Image
              source={require('../../../Assest/Avatar/default.png')}
              style={styles.image}
            />
            // null
          )}
        </TouchableOpacity>
        <View style={styles.ProfileView}>
          <ChakraPetchText style={styles.nameTxt} numberOfLines={1}>
            {name}
          </ChakraPetchText>
          {mobile ? (
            <ChakraPetchText style={styles.numberTxt}>
              {mobile ? '+91 - ' + mobile : null}
            </ChakraPetchText>
          ) : null}
        </View>
        <TouchableOpacity onPress={() => setModalVisible(true)}>
          <Icon1
            name="cog-outline"
            size={32}
            color={'#EA5845'}
            style={styles.setting}
          />
        </TouchableOpacity>
      </View>
      <View style={styles.tabScreenView}>
        <ProfileBarScreen />
        <TouchableOpacity
          style={styles.buttonSave}
          activeOpacity={0.9}
          onPress={() => SaveUserDetails()}>
          <LottieView
            style={styles.flashView}
            speed={1}
            source={require('../../lottieFiles/Save.json')}
            autoPlay={true}
          />
        </TouchableOpacity>
      </View>
      <View style={styles.centeredView}>
        <Modal
          animationType="slide"
          transparent={true}
          visible={modalVisible}
          onRequestClose={() => {
            setModalVisible(!modalVisible);
          }}>
          <View style={styles.centeredView}>
            <ImageBackground
              resizeMode="cover"
              source={require('../../../Assest/PageBG.jpg')}
              style={styles.modalView}>
              <View style={styles.modalContainer}>
                <View style={styles.notificationView}>
                  <ChakraPetchText style={styles.notificationTxt}>
                    NOTIFICATION
                  </ChakraPetchText>
                  <View style={styles.soundView}>
                    <ChakraPetchText style={styles.soundTxt}>
                      Sound
                    </ChakraPetchText>
                    <Switch
                      style={styles.soundswitch}
                      thumbColor={Notification ? thumbColorOn : thumbColorOff}
                      trackColor={{false: trackColorOff, true: trackColorOn}}
                      ios_backgroundColor={trackColorOff}
                      onValueChange={NotificationSwitch}
                      value={Notification}
                    />
                  </View>
                </View>
                <View style={styles.tuneView}>
                  <ChakraPetchText style={styles.tuneTxt}>
                    Choose Notification Tone
                  </ChakraPetchText>
                  <TouchableOpacity style={styles.defaultView}>
                    <ChakraPetchText style={styles.defaultTxt}>
                      Default notification tone
                    </ChakraPetchText>
                    <Icon
                      name="chevron-down"
                      size={22}
                      color={'#C384F8'}
                      style={styles.arrow}
                    />
                  </TouchableOpacity>
                </View>
                <View style={styles.networkView}>
                  <ChakraPetchText style={styles.networkTxt}>
                    NETWORK
                  </ChakraPetchText>
                  <View style={styles.descriveView}>
                    <ChakraPetchText style={styles.descriveTxt}>
                      Describe Network Here
                    </ChakraPetchText>
                    <Switch
                      style={styles.switch}
                      thumbColor={network ? thumbColorOn : thumbColorOff}
                      trackColor={{false: trackColorOff, true: trackColorOn}}
                      ios_backgroundColor={trackColorOff}
                      onValueChange={NetworkSwitch}
                      value={network}
                    />
                  </View>
                </View>
                <View style={styles.shotcutView}>
                  <ChakraPetchText style={styles.shotcutTxt}>
                    SHOTCUTS
                  </ChakraPetchText>
                  <ChakraPetchText style={styles.homeTxt}>
                    Homework
                  </ChakraPetchText>
                  <View style={styles.checkshow}>
                    <ChakraPetchText style={styles.homedes}>
                      Check to show Homework shortcut
                    </ChakraPetchText>

                    <CheckBox
                      // disabled={false}
                      value={homework}
                      onValueChange={newValue => setHomeWork(newValue)}
                      tintColors={{true: '#F15927', false: '#fff'}}
                      style={{transform: [{scaleX: 1.3}, {scaleY: 1.3}]}}
                    />
                  </View>
                </View>
              </View>
            </ImageBackground>
          </View>
        </Modal>
      </View>
    </ImageBackground>
  );
};

export default Profile;
