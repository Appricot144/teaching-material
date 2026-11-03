// mmdc が使う puppeteer の設定。
// puppeteer 付属の Chrome はダウンロードせず、システムに入れた Chromium を使う。
module.exports = {
  skipDownload: true,
  executablePath: '/usr/bin/chromium',
};
