FROM --platform=linux/amd64 ruby:3.2.0

# DockerのWorkdirを引数として取得
ARG SOURCE_DIR

# 公開するポートを明示的に定義
EXPOSE 3000

# 環境変数の設定
ENV APP_ROOT=${SOURCE_DIR} \
    LANGUAGE=ja_JP.UTF-8 \
    LANG=ja_JP.UTF-8 \
    LC_CTYPE=ja_JP.UTF-8 \
    TZ=Asia/Tokyo

# 最低限必要なライブラリを取得する
# https://qiita.com/tomtang/items/4c8e7c5ae8e90230f907
RUN apt-get update -qq && \
    apt-get install -y build-essential

# debian 環境の場合、curl を利用すると `gpg: no valid OpenPGP data found.` というエラーが出るので wget でインストール
# https://zenn.dev/junki555/articles/2de6024a191913
RUN apt-get install -y wget apt-transport-https && \
    wget --quiet -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Selenium用にChromeをインストール
# https://gist.github.com/varyonic/dea40abcf3dd891d204ef235c6e8dd79
# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Update the package list and install chrome
RUN apt-get update && apt-get install -y google-chrome-stable

# 作業ディレクトリを指定し、Gemfile をコピー
WORKDIR ${APP_ROOT}
COPY ./Gemfile* ${APP_ROOT}/

# Gemfile の定義を Image に反映させる
RUN bundle install -j4 --retry 3

# foreman gemのインストール
#RUN gem install foreman
