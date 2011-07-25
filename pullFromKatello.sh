#! /bin/bash

if [ ! -n "$KATELLO" ]; then
    # Default to assuming a sibling dir called 'katello'
    KATELLO=../katello
fi

cp $KATELLO/src/app/stylesheets/katello.scss ./app/stylesheets
cp $KATELLO/src/app/stylesheets/grid.scss ./app/stylesheets
cp $KATELLO/src/app/stylesheets/fancyqueries.scss ./app/stylesheets
cp $KATELLO/src/app/stylesheets/_*.scss ./app/stylesheets
cp $KATELLO/src/app/stylesheets/sections/loginpage.scss ./app/stylesheets/sections

cp $KATELLO/src/public/stylesheets/images/* ./public/stylesheets/images

cp $KATELLO/src/app/views/layouts/katello.haml ./app/views/layouts
cp $KATELLO/src/app/views/layouts/_tupane_layout.html.haml ./app/views/layouts
cp $KATELLO/src/app/views/layouts/_footer.haml ./app/views/layouts
cp $KATELLO/src/app/views/common/_panel.html.haml ./app/views/common
cp $KATELLO/src/app/views/common/_list_item.html.haml ./app/views/common
cp $KATELLO/src/app/views/common/_list_remove.js.haml ./app/views/common
cp $KATELLO/src/app/views/common/_list_update.html.haml ./app/views/common
cp $KATELLO/src/app/views/common/_common_i18n.html.haml ./app/views/common
cp $KATELLO/src/app/views/common/_edit_i18n.html.haml ./app/views/common
cp $KATELLO/src/app/views/common/_tupane.html.haml ./app/views/common

cp $KATELLO/src/public/javascripts/panel.js ./public/javascripts
cp $KATELLO/src/public/javascripts/katello.js ./public/javascripts
cp $KATELLO/src/public/javascripts/search.js ./public/javascripts
cp $KATELLO/src/public/javascripts/scroll_pane.js ./public/javascripts

cp $KATELLO/src/public/fakedata.html ./public
cp -r $KATELLO/src/public/images ./public

cp $KATELLO/src/app/controllers/auto_complete_search.rb ./app/controllers
cp $KATELLO/src/app/helpers/search_helper.rb ./app/helpers
cp $KATELLO/src/app/helpers/layout_helper.rb ./app/helpers
