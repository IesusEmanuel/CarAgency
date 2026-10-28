/* DELETE
 */
/* DELETE FROM veiculos
WHERE slug = 'honda-civic-touring-2024' COLLATE NOCASE; */

/* DELETE FROM veiculos
WHERE slug != 'honda-civic-touring-2024' COLLATE NOCASE;
 */
/* TROCAR VEICULO EM DESTAQUE */
   UPDATE veiculos SET destaque = 0;

   UPDATE veiculos
   SET destaque = 1,
       video_url = 'video/destaque-audi-rs6.mp4'
   WHERE slug = 'Honda-Civic-Touring-2024' COLLATE NOCASE;