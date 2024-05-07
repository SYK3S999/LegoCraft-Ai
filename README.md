# LegoCraftAI: Lego Detection and Shape Advisor

!LegoCraftAI Logo

## Overview

LegoCraftAI is an AI-powered app that combines Lego detection, classification, and shape recommendations. Whether you’re a Lego enthusiast, a parent building with your kids, or a designer seeking inspiration, LegoCraftAI has you covered. Let’s dive into the details:

- **Lego Detection**: Using YOLOv8, LegoCraftAI identifies individual Lego pieces in images or live camera feeds. It recognizes various Lego shapes, including bricks, plates, tiles, and more.

- **Classification by Dimensions**: Once detected, each Lego piece is classified based on its dimensions (e.g., 2x2, 1x4, etc.). This information is crucial for building accurate designs.

- **Shape Recommendations**:
  - Given the detected Lego pieces, LegoCraftAI suggests possible shapes you can build. Whether it’s a spaceship, castle, or robot, the app provides inspiration.
  - Users can input their desired dimensions or constraints (e.g., “Build a tower using only 1x1 bricks”) to receive tailored recommendations.

- **Flutter Interface**:
  - The user-friendly Flutter interface allows users to capture images, view detected Lego pieces, and explore shape ideas.
  - Users can interact with the app via their mobile devices or web browsers.

## Installation

1. **Clone this repository**:
   ```bash
   git clone https://github.com/yourusername/LegoCraftAI.git
