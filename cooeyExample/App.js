import React from 'react';
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';
import { VoiceBPMonitor, CooeyEvents} from 'react-native-cooey';

const bpMonitor = VoiceBPMonitor;

export default class App extends React.Component {

  constructor(props) {
    super(props)
    this.eventListerner = CooeyEvents.addListener(
      "voice_bp_connection",
      this.connectionChange.bind(this)
    );
    this.state = {
      connected:false
    }
  }

  connectionChange(status) {
    this.setState({connected:status});
  }
  render() {
    let title = this.state.connected ? "Take Reading" : "connect BP"
    return (
      <View style={styles.container}>

        <TouchableOpacity onPress={() => {
          if(this.state.connected) {
            bpMonitor.takeReading()
          }else {
            bpMonitor.connectBPMonitor();
          }
      
        }}>
          <Text style={{borderWidth:1, padding:10}}>{title}</Text>
        </TouchableOpacity>
      </View>
    );
  }

  
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
