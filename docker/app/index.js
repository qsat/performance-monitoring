const puppeteer = require('puppeteer')
const lighthouse = require('lighthouse')
const { URL } = require('url')

const main = async () => {
  const browser = await puppeteer.launch({
    executablePath: 'google-chrome-unstable',
    args: [
      '--disable-dev-shm-usage',
      '--lang=ja,en-US,en'
    ]
  })
  const target = 'https://google.com'
  // const page = await browser.newPage();

  const { lhr } = await lighthouse(target, {
    port: (new URL(browser.wsEndpoint())).port,
    output: 'json',
    logLevel: 'info',
  });

  console.log(`Lighthouse scores: ${Object.values(lhr.categories).map(c => c.score).join(', ')}`);

  await browser.close();

  return { lhr }
}

main().then((ret) => {
  console.log(ret)
})

