# Gallery App

## About

An iOS application for discovering new images using the most powerful photo engine in the world.

## Overview

Application is available from iOS 15 and consists of two screens:
1. Image Collection Screen
2. Image Details Screen
<br><br>

### Image Collection Screen

<img src="https://github.com/user-attachments/assets/0d3fff9d-8ea2-4ec4-a1a2-2dde46290820" width="265" >
<img src="https://github.com/user-attachments/assets/87921206-fe63-44f8-91c3-5196d9acd0d3" width="265" >
<img src="https://github.com/user-attachments/assets/91c1e738-77c7-4a9b-a8fc-8a7a60c2431b" width="265" >
<br><br>

Image Collection Screen displays a grid of thumbnail images fetched from Unsplash API. Each thumbnail is tappable and leads to the Image Details Screen. Implemented pagination to load more images as the user scrolls to the bottom of Image Collection Screen. User can apply filter to show only favourite images by tapping on heart-shaped button in navigation bar.
<br><br>

### Image Details Screen

<img src="https://github.com/user-attachments/assets/b5da66b0-fa00-4936-be48-1265e5cd0c44" width="265" >
<img src="https://github.com/user-attachments/assets/c8c24596-fff2-493e-9d73-ee3590f771a7" width="265" >
<br><br>

Image Details Screen shows selected image in a larger view with image description at the bottom. User can mark image as favourite by tapping a heart-shaped button in the top right corner. User can navigate between images in the details view using right and left swipe gestures.
<br><br>

### Errors handling

<img src="https://github.com/user-attachments/assets/e97dc3eb-b9cf-4508-af58-442f2829e53c" width="265" >
<img src="https://github.com/user-attachments/assets/4dde850f-e3e4-460c-b742-e5f7fa64c5da" width="265" >
<img src="https://github.com/user-attachments/assets/d12b5cb4-cfca-4af5-b72a-1248de298f27" width="265" >
<br><br>

Implemented errors handling and displaying error messages to the user using alerts. Alerts actions allow user to reload application or even ignore errors. When image loading errors occur, image will be displayed in Image Collection Screen as a loading arrow icon with black background.
<br><br>

### Data storing

Information about favourite images is stored locally on the user device. It is implemented by saving favourite image ID, image data and description.  


## Technologies & Implementation

|      Category       |  Solution   |
|---------------------|:------------|
| Language            | Swift       |
| UI framework        | UIKit       |
| Networking          | URLSession  |
| Multithreading      | GCD         |
| Data persistence    | FileManager |
| Architecture pattern| MVVM        |

## Contacts

Telegram: @vllmnd

Email: uladzislauklunduk@gmail.com

LinkedIn: www.linkedin.com/in/ulkl
