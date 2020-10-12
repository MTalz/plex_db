SELECT DISTINCT 
library_sections.name AS Libary, 
metadata_series.title AS Series,
CASE 
	WHEN library_sections.name = "Anime Series" OR library_sections.name = "TV Series" THEN MAX(metadata_season.'index')
	ELSE NULL
END AS 'No. of Seasons',
CASE 
	WHEN library_sections.name = "Anime Series" OR library_sections.name = "TV Series" THEN NULL
	ELSE metadata_media.title
END AS Title,
metadata_media.year AS Year,
replace(metadata_media.tags_star,'|',', ') AS Starring,
replace(metadata_media.tags_director,'|',', ') AS 'Director(s)',
replace(metadata_media.tags_writer,'|',', ') AS 'Writer(s)',
replace(metadata_media.tags_genre,'|',', ') AS 'Genre(s)',
replace(metadata_media.tags_country,'|',', ') AS Countries,
round(metadata_media.rating) AS Rating,
metadata_media.content_rating AS 'Content Rating',
CASE 
	WHEN library_sections.name = "Movies" THEN SUBSTR(metadata_media.duration,0,5)/60 
	ELSE NULL
END AS 'Run Time (mins)',
metadata_media.summary AS Summary
FROM media_items
INNER JOIN metadata_items as metadata_media
ON media_items.metadata_item_id = metadata_media.id
LEFT JOIN metadata_items as metadata_season
ON metadata_media.parent_id = metadata_season.id
LEFT JOIN metadata_items as metadata_series
ON metadata_season.parent_id = metadata_series.id
INNER JOIN section_locations
ON media_items.section_location_id = section_locations.id
INNER JOIN library_sections
ON library_sections.id = section_locations.library_section_id
GROUP BY 
CASE
	WHEN library_sections.name = "Anime Series" OR library_sections.name = "TV Series" THEN metadata_series.title
	ELSE metadata_media.title
END
ORDER BY library_sections.name,
CASE
	WHEN library_sections.name = "Music" THEN metadata_series.title
	ELSE metadata_media.title
END
