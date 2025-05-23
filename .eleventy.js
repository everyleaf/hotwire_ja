import { EleventyHtmlBasePlugin } from "@11ty/eleventy";
import syntaxHighlight from "@11ty/eleventy-plugin-syntaxhighlight";
import markdownItAnchor from "markdown-it-anchor";
import markdownItToc from "markdown-it-toc-done-right";
import markdownIt from "markdown-it";

export default function (eleventyConfig) {
  eleventyConfig.setLibrary("md", markdownIt({
    html: true,
    linkify: true,
    typographer: true
  }));

  eleventyConfig.amendLibrary("md", (mdLib) => {
    return mdLib.use(markdownItAnchor, { // add anchors to headings
      level: '2',
      permalink: markdownItAnchor.permalink.ariaHidden({
        class: 'anchor',
        symbol: '#',
        placement: 'before'
      })
    });
  });

  eleventyConfig.amendLibrary("md", (mdLib) => {
    return mdLib.use(markdownItToc, { // make a TOC with ${toc}
      level: '2',
      listType: 'ul'
    });
  });

  const navigations = [
    'turbo_handbook',
    'turbo_reference',
    'stimulus_handbook',
    'stimulus_reference',
  ];

  navigations.forEach((nav) => {
    eleventyConfig.addCollection(nav, collectionApi => {
      return collectionApi.getFilteredByTag(nav).sort((a, b) => {
        return a.data.order - b.data.order;
      });
    });
  });

  eleventyConfig.addPlugin(EleventyHtmlBasePlugin);
  eleventyConfig.addPlugin(syntaxHighlight);
  eleventyConfig.addPassthroughCopy({'_assets': 'assets'});
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
