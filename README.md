## 目的
iPhoneで撮影した動画のファイルフォーマットがMOV拡張子のため、<br>
様々なメディアプレイヤーで再生できるようにフォーマット変換を行うバッチ処理を作成しました。

## 処理の概要
HandBrake CLIが動作する環境が前提となっており、bashを使用しています。<br>
よって、Windowsで動作させるにはGit BashやBash On Ubuntu On Windowsなどの環境セットアップが必要です。<br>
シェルスクリプトは、特定のディレクトリをチェックし、<br>
".MOV"の拡張子ファイルが存在している場合は、そのファイルをMP4に変換します。<br>
変換に成功した件数が1件でもある場合はSlackにその旨を通史します。

## 利用する環境変数
| 項目名 | 説明 |
----|---- 
| PATH | HandBrakeCLIコマンドの実行体があるファイルパスを登録しておくこと。 |
| HANDBRAKECLI_INPUT_PATH | 入力ファイルパスを設定する。深い階層構造も見に行く(コード参照)。 |
| HANDBRAKECLI_MAX_FILE_COUNT | 処理する動画の最大数。<br>例えば動画が100あった場合にシェルスクリプトが終わらない可能性もあるので、本パラメータで最大処理数を制御する。 |
| HANDBRAKECLI_WEBHOOKURL | SlackのWeb Hook URLを指定すること。 |

## スケジュール設定の例
### cronの場合
```
# Macの設定例
0 0-23/3 * * * /bin/bash -l /handBrake-CLI-script/handBrake-automate-encoding.sh
```

## WindowsでコマンドプロンプトからGit Bashを起動して実行する例
```
rem 下記内容をbatファイルにしてタスクスケジューリングすると良い
cd "%ProgramFiles%\Git\bin\"
sh -x D:\tech\xblood-handBrake-CLI-encode-script\handBrake-automate-encoding.sh
```

## 参考サイト
https://itjo.jp/pc/handbrake-rotate-movie
