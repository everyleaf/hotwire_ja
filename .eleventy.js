const { EleventyHtmlBasePlugin } = require("@11ty/eleventy");
const markdownItAnchor = require('markdown-it-anchor');

// enable everything
var md = require('markdown-it')({
  html: true,
  linkify: true,
  typographer: true
});

module.exports = function(eleventyConfig) {
  md.use(markdownItAnchor, { // add anchors to headings
    level: '2',
    permalink: 'true',
    permalinkClass: 'anchor',
    permalinkSymbol: '﹟',
    permalinkBefore: 'true'
  });

  eleventyConfig.addPlugin(EleventyHtmlBasePlugin);
  eleventyConfig.addPassthroughCopy({ '_assets': 'assets' });
  eleventyConfig.setLibrary('md', md);

  return {
    dir: {
      layouts: "layouts",
      includes: "_includes",
    },
    templateFormats: ['html', 'md', 'liquid', 'njk'],
    htmlTemplateEngine: 'liquid',
    pathPrefix: "/",
  }
};
