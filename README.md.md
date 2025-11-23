🎧 Spotify Music Analytics using SQL & PostgreSQL
📌 Project Overview

This project analyzes 114,000+ global Spotify tracks using PostgreSQL to extract business-driven insights about popularity trends, audio features, artists, and genre performance.
The goal is to understand what makes a hit song and how music streaming success is influenced by characteristics like tempo, loudness, duration, mood, and explicit content.

🛠️ Tools & Technologies Used
Tool	Purpose
PostgreSQL	Data analysis using SQL
Excel / Power BI	Interactive Dashboard (to be added)
GitHub	Version control & portfolio showcase
📂 Dataset Details

Name: Spotify Tracks Dataset

Records: 114k+ songs

Columns: 20 attributes

Key fields: Popularity, Genre, Artists, Duration, Danceability, Energy, Tempo, Explicit, Valence, Loudness

Dataset Source: Kaggle
(Spotify Tracks — Global Music Data)

📊 Key Business Questions Solved
🎶 Popularity & Streaming Analysis

✔ Top 10 most popular tracks globally
✔ Popularity distribution by genres
✔ Most viral artists

🎧 Genre Insights

✔ Genres with highest popularity
✔ Happiest / Energetic / Calmest genres
✔ Fastest tempo genres

👑 Artist Performance Insights

✔ Top artists by volume and popularity
✔ Danceability, loudness & mood comparison

🔊 Audio Feature Correlations

✔ Popularity vs Danceability
✔ Popularity vs Loudness
✔ Popularity vs Valence (mood)
✔ Mode analysis (minor vs major)

✔ Found that medium danceability, medium loudness, and low valence (emotional) songs perform best.

🚫 Explicit Content Insights

✔ Only 8.55% songs are explicit
✔ Explicit songs show slightly higher popularity

⏱ Duration & Tempo Optimization

✔ Radio-friendly length: 2.5 – 4 minutes
✔ Fast tempo (>120 BPM) performs best

🧠 Final Business Recommendations
Factor	Ideal for a Hit Song	Reason
Duration	2.5–4 minutes	Playlist & radio optimal
Tempo	90–120+ BPM	Higher engagement
Danceability	Medium–High	Better listener retention
Loudness	Moderately loud	Balanced excitement
Mood (Valence)	Slightly emotional	Higher viral potential
Explicit Content	Low	Wider listenership

Music with high energy, emotional themes, and radio-friendly length performs best on Spotify.

📌 What I Learned

✔ Complex SQL (CTE, Window Functions, Aggregations, CASE)
✔ Data cleaning & transformation
✔ Music analytics & commercial storytelling
✔ Dashboard design for business use
✔ GitHub-style project documentation

📷 Dashboard (Coming Soon)

📁 /dashboard/Spotify_Dashboard.xlsx
📌 Will include:

Genre performance visuals

Artist insights

Audio-feature charts

KPIs and slicers

📁 Project Structure
Spotify-SQL-Analytics-Project/
│
├── data/
│   └── spotify.csv
├── queries/
│   └── spotify_analysis.sql
├── dashboard/
│   └── Spotify_Dashboard.xlsx (coming soon)
├── insights/
│   └── business_insights.md
└── README.md

🚀 Future Enhancements

Machine Learning model to predict song popularity

Spotify Web API integration for real-time analysis

Deployment with dashboards and APIs

🙋‍♂️ Author

Vedang Doley
Aspiring Data Scientist | PostgreSQL | Python | Analytics
📍 India
🔗 LinkedIn (Will add link later)

⭐ Support

If you like this project, please ⭐ the repository!
It helps others discover it 🙌