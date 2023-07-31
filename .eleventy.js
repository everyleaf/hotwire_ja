// enable everything
var md = require('markdown-it')({
  html: true,
  linkify: true,
  typographer: true
});

module.exports = function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy({ '_assets': 'assets' });
  return {
    dir: {
      includes: "layouts",
    }
  }
};
