import { HtmlBasePlugin } from "@11ty/eleventy";
import syntaxHighlight from "@11ty/eleventy-plugin-syntaxhighlight";
import markdownItAnchor from "markdown-it-anchor";
import markdownItToc from "markdown-it-toc-done-right";
import markdownIt from "markdown-it";

export default function (eleventyConfig) {
  let options = {
		html: true,
		breaks: true,
		linkify: true,
	};
  eleventyConfig.setLibrary("md", markdownIt(options));

  eleventyConfig.amendLibrary("md", (mdLib) => {
    return mdLib.use(markdownItAnchor, { // add anchors to headings
      level: '2',
      permalink: 'true',
      permalinkClass: 'anchor',
      permalinkSymbol: '﹟',
      permalinkBefore: 'true'
    });
  });

  eleventyConfig.amendLibrary("md", (mdLib) => {
    return mdLib.use(markdownItToc, { // make a TOC with ${toc}
      level: '2',
      listType: 'ul'
    });
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

  eleventyConfig.addPlugin(HtmlBasePlugin);
  eleventyConfig.addPlugin(syntaxHighlight);
  eleventyConfig.addPassthroughCopy({ '_assets': 'assets' });
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
