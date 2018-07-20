import React from 'react';
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';
import { VoiceBPMonitor, CooeyEvents} from 'react-native-cooey';

const eventsForCooey = CooeyEvents;
const bpMonitor = VoiceBPMonitor;

export default class App extends React.Component {
  render() {
    return (
      <View style={styles.container}>

        <TouchableOpacity onPress={() => {
          bpMonitor.connectBPMonitor();
        }}>
          <Text style={{borderWidth:1, padding:10}}>{"connect BP"}</Text>
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
