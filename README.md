## 目的
iPhoneで撮影した動画のファイルフォーマットがMOV拡張子のため、<br>
様々なメディアプレイヤーで再生できるようにフォーマット変換を行うバッチ処理を作成しました。

## 処理の概要
HandBrake CLIが動作する環境が前提となっており、<br>
bashを使用しています。よって、Windowsで動作させるにはGit BashやBash On Ubuntu On Windowsなどの環境セットアップが必要です。<br>
シェルスクリプトは、特定のディレクトリをチェックし、<br>
".MOV"の拡張子ファイルが存在している場合は、そのファイルをMP4に変換します。<br>

変換に成功した件数が1件でもある場合はSlackにその旨を通史します。

## スケジュール設定
cronで行なっています。<br>
例）Macの設定例<br>
0 0-23/3 * * * /bin/bash -l /handBrake-CLI-script/handBrake-automate-encoding.sh
