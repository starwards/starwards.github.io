#!/bin/bash
set -e

echo "Running post-create setup..."

# If there's a Gemfile, then run `bundle install`
# It's assumed that the Gemfile will install Jekyll too
if [ -f Gemfile ]; then
    echo "Configuring bundler to use local path..."
    bundle config set --local path 'vendor/bundle'

    echo "Installing gems from Gemfile..."
    bundle install
    echo "Gems installed successfully!"
else
    # If there's no Gemfile, install Jekyll
    echo "No Gemfile found, installing Jekyll directly..."
    sudo gem install jekyll
    echo "Jekyll installed successfully!"
fi

echo "Post-create setup completed!"
