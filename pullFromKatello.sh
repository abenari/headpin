#! /bin/bash

KATELLO=/home/bkearney/code/kalpana

cp $KATELLO/src/app/stylesheets/kalpana.scss ./app/stylesheets
cp $KATELLO/src/app/stylesheets/screen.scss ./app/stylesheets
cp $KATELLO/src/app/stylesheets/grid.scss ./app/stylesheets
cp $KATELLO/src/app/stylesheets/_*.scss ./app/stylesheets

cp $KATELLO/src/app/views/layouts/kalpana.haml ./app/views/layouts
cp $KATELLO/src/app/views/layouts/_footer.haml ./app/views/layouts
cp $KATELLO/src/app/views/common/_panel.html.haml ./app/views/common
cp $KATELLO/src/app/views/common/_list_item.html.haml ./app/views/common

cp $KATELLO/src/public/javascripts/panel.js ./public/javascripts
cp $KATELLO/src/public/javascripts/kalpana.js ./public/javascripts
