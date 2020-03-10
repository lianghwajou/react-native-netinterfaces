import { NativeModules } from 'react-native';

const { RNNetinterfaces } = NativeModules;

const NetInterfaces = {
    async getInterfaces() {
        return await RNNetinterfaces.getInterfaces();
    }
}

export { NetInterfaces };
