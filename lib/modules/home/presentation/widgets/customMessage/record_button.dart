import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class RecordButton extends StatefulWidget {
  final Function(bool tapStatus) getTapStatus;
  final Function(String? recordPath) sendRecord;

  const RecordButton({
    Key? key,
    required this.getTapStatus,
    required this.sendRecord,
  }) : super(key: key);

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  late final RecorderController recorderController;
  bool isRecording = false;
  late Directory appDirectory;

  @override
  void initState() {
    _getDir();
    _initialiseControllers();
    super.initState();
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    setState(() {});
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  @override
  Widget build(BuildContext context) {
    return isRecording ? audioWaveButton() : audioButton();
  }

  Widget audioWaveButton() {
    return Expanded(
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              Vibrate.feedback(FeedbackType.heavy);
              recorderController.reset();
              String? tempPath = await recorderController.stop(false);
              if (tempPath != null) {
                debugPrint(tempPath);
                File(tempPath).delete();
              }
              setState(() => isRecording = false);
              widget.getTapStatus(false);
            },
            icon: const Icon(Icons.delete),
          ),
          Expanded(
            child: AudioWaveforms(
              size: Size(MediaQuery.of(context).size.width, AppSize.s50),
              recorderController: recorderController,
              waveStyle: WaveStyle(
                waveColor: ColorManager.kWhite,
                extendWaveform: true,
                showMiddleLine: false,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s12),
                color: ColorManager.kBlack,
              ),
              padding: const EdgeInsets.only(left: AppPadding.p18),
              margin: const EdgeInsets.symmetric(horizontal: AppPadding.p15),
            ),
          ),
          InkWell(
            onTap: () async {
              Vibrate.feedback(FeedbackType.success);
              recorderController.reset();
              String? tempPath = await recorderController.stop(false);
              widget.sendRecord(tempPath);
              setState(() => isRecording = false);
              widget.getTapStatus(false);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppPadding.p10,
              ),
              height: AppSize.s45,
              width: AppSize.s45,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.primary,
              ),
              child: Icon(
                Icons.send,
                color: ColorManager.kWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget audioButton() {
    return GestureDetector(
      child: Container(
        child: Icon(
          Icons.mic,
          color: ColorManager.kWhite,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppPadding.p10,
        ),
        height: AppSize.s45,
        width: AppSize.s45,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorManager.primary,
        ),
      ),
      onTap: () async {
        debugPrint("ontapPress");
        if (await recorderController.checkPermission()) {
          var path =
              "${appDirectory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a";
          await recorderController.record(path: path);
          setState(() => isRecording = true);
          widget.getTapStatus(true);
        }
      },
    );
  }
}
