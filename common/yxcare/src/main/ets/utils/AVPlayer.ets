import media from '@ohos.multimedia.media';

export class AVPlayerClass {
  static avPlayer: media.AVPlayer | null = null
  static audioName: string = ''
  static isSettingBack: boolean = false

  static async playAudio(audioName: string) {
    if (!AVPlayerClass.avPlayer) {
      AVPlayerClass.avPlayer = await media.createAVPlayer()
    }
    if (audioName) {
      AVPlayerClass.audioName = audioName
      AVPlayerClass.setAvPlayerName(getContext())
    }
  }

  static async setAvPlayerName(context: Context) {
    try {
      let fileDescriptor = await context.resourceManager.getRawFd(AVPlayerClass.audioName);
      let avFileDescriptor: media.AVFileDescriptor =
        { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length }
      if (!AVPlayerClass.isSettingBack) {
        AVPlayerClass.setAvPlayerCallBack() // 设置回调
      }
      if (AVPlayerClass.avPlayer) {
        AVPlayerClass.avPlayer.fdSrc = avFileDescriptor // 设置播放源
      }
    } catch (error) {
      AlertDialog.show({
        message: error.message
      })
    }

  }

  static setAvPlayerCallBack() {
    if (AVPlayerClass.avPlayer) {
      AVPlayerClass.isSettingBack = true
      // seek操作结果回调函数
      AVPlayerClass.avPlayer!.on('seekDone', (seekDoneTime: number) => {
        // console.info(`AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
        AVPlayerClass.avPlayer!.play() // 回拨到0秒后 开始播放
      })
      // error回调监听函数,当avPlayer在操作过程中出现错误时调用 reset接口触发重置流程
      // 状态机变化回调函数
      AVPlayerClass.avPlayer!.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
        switch (state) {
          case 'initialized': // avplayer 设置播放源后触发该状态上报
            console.info('AVPlayer state initialized called.');
            AVPlayerClass.avPlayer!.prepare();
            break;
          case 'prepared': // prepare调用成功后上报该状态机
            console.info('AVPlayer state prepared called.');
            AVPlayerClass.avPlayer!.seek(0) // 准备好之后 将音频回拨到0秒
            break;
          case 'playing': // play成功调用后触发该状态机上报
            console.info('AVPlayer state playing called.');
            break;
          case 'paused': // pause成功调用后触发该状态机上报
            console.info('AVPlayer state paused called.');
            break;
          case 'completed': // 播放结束后触发该状态机上报
            console.info('AVPlayer state completed called.');
            AVPlayerClass.avPlayer!.reset(); //调用播放结束接口
            break;
          case 'stopped': // stop接口成功调用后触发该状态机上报
            console.info('AVPlayer state stopped called.');
            break;
          case 'released':
            console.info('AVPlayer state released called.');
            break;
          default:
            console.info('AVPlayer state unknown called.');
            break;
        }
      })
    }

  }
}