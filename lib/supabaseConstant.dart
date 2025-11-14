ALTER TABLE orders ADD COLUMN IF NOT EXISTS customer_city TEXT;

INSERT INTO storage.buckets (id, name, public)
VALUES ('order_images', 'order_images', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "public_read_order_images" ON storage.objects;
CREATE POLICY "public_read_order_images" ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'order_images');

DROP POLICY IF EXISTS "affiliates_upload_order_images" ON storage.objects;
CREATE POLICY "affiliates_upload_order_images" ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'order_images');