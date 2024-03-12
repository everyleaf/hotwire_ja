const { EleventyHtmlBasePlugin } = require("@11ty/eleventy");
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
const markdownItAnchor = require('markdown-it-anchor');
const markdownItToc = require('markdown-it-toc-done-right');

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
  md.use(markdownItToc, { // make a TOC with ${toc}
    level: '2',
    listType: 'ul'
  });

  eleventyConfig.addCollection('turbo_handbook', collectionApi => {
    return collectionApi.getFilteredByTag('turbo_handbook').sort((a, b) => {
      return a.data.order - b.data.order;
    });
  })

  eleventyConfig.addCollection('turbo_reference', collectionApi => {
    return collectionApi.getFilteredByTag('turbo_reference').sort((a, b) => {
      return a.data.order - b.data.order;
    });
  })

  eleventyConfig.addPlugin(EleventyHtmlBasePlugin);
  eleventyConfig.addPlugin(syntaxHighlight);
  eleventyConfig.addPassthroughCopy({ '_assets': 'assets' });
  eleventyConfig.setLibrary('md', md);
  eleventyConfig.setDataDeepMerge(true);

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
