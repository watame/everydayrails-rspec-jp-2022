[![RSpec](https://github.com/JunichiIto/everydayrails-rspec-jp-2022/actions/workflows/rspec.yml/badge.svg)](https://github.com/JunichiIto/everydayrails-rspec-jp-2022/actions/workflows/rspec.yml)

# *Everyday Rails Testing with RSpec* sample application (2022 Japanese edition)

Sample Rails application for *[Everyday Rails Testing with RSpec](https://leanpub.com/everydayrailsrspec): A
Practical Approach to Test-driven Development* by Aaron Sumner. This
repository is the official fork for the 2022 Japanese edition.

----

このリポジトリのRailsアプリは「 [Everyday Rails - RSpecによるRailsテスト入門](https://leanpub.com/everydayrailsrspec-jp/) 」のサンプルアプリケーションです。

2022年更新の日本語版より、 [原著のソースコード](https://github.com/everydayrails/everydayrails-rspec-2017) をフォークし、日本語版独自にメンテナンスしていくことになりました。

<img width="323" alt="cover image" src="https://user-images.githubusercontent.com/1148320/149681452-f3308367-831d-44dc-8c0b-cd9ba795cc6e.jpg">

このリポジトリでは既存のアプリケーションに対して、少しずつテストを追加していく過程を説明します。最初はまったくテストのないコードベースから始まり、
モデルスペック、コントローラスペック、システムスペック、リクエストスペックと順に進みます。

このリポジトリの各ブランチを開くと、各章で追加したコードが確認できます。詳しくは本書の第1章をご覧ください。

Gitを使うとブランチ名を指定して各バージョンをチェックアウトできます。詳しくは本書をご覧ください。

Gitが苦手な方は、GitHubの便利な ブランチ機能を利用してください。
フィルターで特定のブランチを選択し、オンラインでソースコードをブラウズすることができます。

Gitについてもっと詳しく知りたい方は、無料で公開されている「 [Git Immersion](http://gitimmersion.com/) 」または「 [Try Git](http://www.codeschool.com/courses/try-git) 」（いずれも英語版）がお勧めです。

# Dockerでの利用方法
以下のステップでdocker-composeでの利用が可能

1.コンテナイメージの作成
```
$ docker-compose build
```

2.DBの初期設定
```
$ docker-compose run app bin/setup
```

3.JavaScriptモジュール管理ソフトのインストール
```
$ docker-compose run app yarn install
```

3.5.`Procfile.dev`の更新
```ruby
# webのjob定義に-b '0.0.0.0'を付与する
web: bin/rails server -p 3000 -b '0.0.0.0'
```

4.コンテナでの開発サーバ起動
```
$ docker-compose up
```

5.RSpecの実施
```
$ docker-compose run rspec
```