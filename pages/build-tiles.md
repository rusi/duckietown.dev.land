---
title: Build Duckietown
path: /build/duckietown/
---

<section>

# Building Duckietown

Anybody can build their own version of Duckietown. However, to be consistent and to avoid confusion
when Duckies travel from one town to another, every town should follow these rules.

Duckietown has two layers - Tiles and Signs:
* **Tiles**: The first layer is the floor layer. The floor is built of interconnected exercise mats with tape on them. 
* **Signes**: The second layer is signs and other objects that sit on top of the mats. 
* **NOTE**: In the case that Duckietown directly abuts a wall, a perimeter of vertical tiles should be added to reduce visual clutter and false positives.

</section>

<section>

# Buidling the Tiles

Each tile is a 2ft x 2ft interlock square. There are four types of tiles:
* ![two lane](/images/tile-two-lane-small.jpg) **Two lane straight** tile
* ![curved](/images/tile-two-lane-90-small.jpg) **Curved 90deg** tile
* **Three way intersection** tile
* **Four way intersection** tile

</section>

<section>

## Materials

Following is a list of materials required to build the tiles:

* <a target="_blank"  href="https://www.amazon.com/gp/product/B01IDRWPG8/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B01IDRWPG8&linkCode=as2&tag=duckietown-20&linkId=bb91b7d582c9da6c00d76d6a6a57df6d"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B01IDRWPG8&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Foam Interlocking Tiles (2ft x 2ft) (B01IDRWPG8)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B01IDRWPG8" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B003YHBU1O/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B003YHBU1O&linkCode=as2&tag=duckietown-20&linkId=e37f66b7259c681bdf071b5984254f98"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B003YHBU1O&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Duct Tape, Pearl White, 1.88-Inch (B003YHBU1O)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B003YHBU1O" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B000BOAAFA/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B000BOAAFA&linkCode=as2&tag=duckietown-20&linkId=d106b52d405330b242875a026dd0215b"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B000BOAAFA&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Red Electrical Tape, 3/4-Inch (B000BOAAFA)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B000BOAAFA" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B000BQWLF0/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B000BQWLF0&linkCode=as2&tag=duckietown-20&linkId=6305eea6f8afaff8d89218b04fe76edc"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B000BQWLF0&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Yellow Electrical Tape, 3/4-Inch (B000BQWLF0)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B000BQWLF0" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

---
Additional Items:

* <a target="_blank"  href="https://www.amazon.com/gp/product/B00YMRZNTA/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00YMRZNTA&linkCode=as2&tag=duckietown-20&linkId=d7652215f74b7115d07953317ba850d6"><img border="0" src="http://ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B00YMRZNTA&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Rubber Duckies (B00YMRZNTA)</a><img src="http://ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B00YMRZNTA" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B0039N6XVU/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0039N6XVU&linkCode=as2&tag=duckietown-20&linkId=efca5a8e8046a115f45d8aa1115182ec"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B0039N6XVU&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Course/Track Cones (B0039N6XVU)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B0039N6XVU" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

* <a target="_blank"  href="https://www.amazon.com/gp/product/B0012QRPY0/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0012QRPY0&linkCode=as2&tag=duckietown-20&linkId=946f516ac36fec3d7fc06cdb0a4d50d7"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B0012QRPY0&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=duckietown-20" width="40" /> Guidecraft 7" Block Play Traffic Signs (B0012QRPY0)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=duckietown-20&l=am2&o=1&a=B0012QRPY0" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

</section>

<section class="step">

## Making Two Lane Straight Tile

[![two lane straight](/images/tile-two-lane.jpg)](/images/tile-two-lane.jpg)

Use the white 1.88" (5cm) Duck Tape to create the outer lane borders. It is assumed that the **white strip is always on the right** side of the lane. Also, **the white strip is always solid**.

**NOTE** that the while strip is **2cm** away from the inner edge of the interlocking tile.

</section>

<section class="step">

## Making Two Lane 90° Curved Tile

[![two lane straight](/images/tile-two-lane.jpg)](/images/tile-two-lane.jpg)

### Step 1

Use the white 1.88" (5cm) Duck Tape to create the outer lane borders. It is assumed that the **white strip is always on the right** side of the lane. Also, **the white strip is always solid**.

**NOTE** that the while strip is **2cm** away from the inner edge of the interlocking tile.

</section>

<section class="step">

[![two lane straight](/images/tile-two-lane.jpg)](/images/tile-two-lane.jpg)

### Step 2

Use the white 1.88" (5cm) Duck Tape to create the outer lane borders. It is assumed that the **white strip is always on the right** side of the lane. Also, **the white strip is always solid**.

**NOTE** that the while strip is **2cm** away from the inner edge of the interlocking tile.

</section>

<section class="step">

<div class="img-right">

[![two lane straight](/images/tile-two-lane.jpg)](/images/tile-two-lane.jpg)

</div>

### Step 3

Use the white 1.88" (5cm) Duck Tape to create the outer lane borders. It is assumed that the **white strip is always on the right** side of the lane. Also, **the white strip is always solid**.

**NOTE** that the while strip is **2cm** away from the inner edge of the interlocking tile.

</section>