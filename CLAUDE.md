# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **Starwards** project blog (starwards.github.io), a Jekyll-based GitHub Pages site built on the Beautiful Jekyll theme. The blog documents the development of Starwards, a space combat game developed by Helios Games.

## Development Commands

### Local Development

**Preferred method (Docker):**
```bash
docker-compose up
```
This serves the site at http://localhost:4000 with live reload, drafts enabled, and verbose logging.

**Alternative method (native Ruby):**
```bash
bundle exec jekyll serve --watch --drafts --force_polling --verbose
```

### Build

```bash
bundle exec jekyll build
```
Generates the static site into `_site/` directory.

## Content Structure

### Blog Posts

- **Location:** `_posts/`
- **Naming convention:** `YYYY-MM-DD-title.md` (e.g., `2022-06-19-radar-damage.md`)
- **Template:** Use `.post-template` as a starting point for new posts
- **YAML front matter required:**
  ```yaml
  ---
  layout: post
  title: Your Title
  subtitle: Your Subtitle (optional)
  tags: [tag1, tag2, tag3]
  ---
  ```

### Drafts

- **Location:** `_drafts/`
- Drafts are shown when serving with `--drafts` flag
- Drafts starting with `!` in the filename appear to be prioritized/important drafts

### Authors

This site uses a custom authors collection:
- **Location:** `_authors/`
- **Current authors:** amir, daniel, team
- **Default author:** Posts default to "team" (see `_config.yml` defaults)
- Author files contain `short_name` and `name` fields

### Navigation

- **Configuration:** `_data/navigation.yml`
- Defines the main navigation menu items (Home, Tags, Team, Helios Games)

## Architecture

### Layouts (`_layouts/`)

- `base.html` - Base template for all pages
- `default.html` - Standard page wrapper
- `post.html` - Blog post layout with comments, social sharing, tags
- `page.html` - Static page layout
- `home.html` - Homepage layout showing blog post feed
- `author.html` - Author profile layout
- `minimal.html` - Minimal layout without nav/footer

### Includes (`_includes/`)

Reusable components:
- `nav.html` - Navigation bar
- `header.html` - Page header with cover images
- `footer.html` - Site footer
- `comments.html` - Comment system integration (Staticman, Disqus, Facebook, Utterances)
- `social-share.html` - Social media sharing buttons
- `staticman-comments.html` - Staticman comment rendering
- `readtime.html` - Reading time estimation

### Assets

- `assets/css/` - Stylesheets
- `assets/js/` - JavaScript files
- `assets/img/` - Images and media (including video files like `.webm`)

### Configuration (`_config.yml`)

Key settings:
- **Site title:** "Starwards"
- **Authors:** Amir Arad and Daniel Ginat
- **Social links:** GitHub (starwards/starwards), YouTube, Discord
- **Comments:** Staticman enabled with custom endpoint
- **Analytics:** Google Analytics configured
- **Timezone:** America/Toronto
- **Permalink format:** `/:year-:month-:day-:title/`
- **Pagination:** 5 posts per page

### Theme

Built on Beautiful Jekyll theme v5.0.0:
- Responsive, mobile-first design
- Built-in support for cover images, thumbnails, tags, SEO
- Social media integration
- Comment system support
- Google Analytics integration

## Working with Posts

1. Create new post file in `_posts/` following naming convention
2. Copy YAML front matter from `.post-template`
3. Add appropriate tags (common tags: product, design, dogfight)
4. Add content in Markdown format
5. For videos/images, place in `assets/img/` and reference in post
6. Posts automatically appear on homepage and in RSS feed

## Staticman Comments

The site uses Staticman for comments with a custom deployment:
- **Endpoint:** https://amir-staticman.herokuapp.com/
- **Configuration:** `staticman.yml`
- **reCaptcha:** Configured for spam protection

## VSCode Tasks

Pre-configured tasks in `.vscode/tasks.json`:
- **Serve** (default test task): Runs Jekyll server with drafts and live reload
- **Build** (default build task): Builds static site
