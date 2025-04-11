{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import Web.Scotty
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy.Encoding as TLE
import qualified Data.ByteString.Lazy as BL
import Network.Wai.Middleware.Static
import Network.Wai.Parse (FileInfo(..))
import Data.Aeson (object, (.=))
import GHC.Generics (Generic)
import Data.Csv (FromNamedRecord, decodeByName)
import qualified Data.Vector as V
import Data.String (fromString)

data HealthData = HealthData
    { date :: Text
    , heartRate :: Int
    , bloodPressureSystolic :: Int
    , bloodPressureDiastolic :: Int
    , bloodSugar :: Int
    , weight :: Double
    } deriving (Show, Generic)

instance FromNamedRecord HealthData

main :: IO ()
main = scotty 3000 $ do
    middleware $ staticPolicy (addBase "static")

    get "/" $ do
        content <- liftIO $ BL.readFile "static/index.html"
        html (TLE.decodeUtf8 content)

    post "/upload" $ do
        fs <- files
        let maybeFile = lookup "file" fs
        case maybeFile of
            Just uploadedFile -> do
                let content = fileContent uploadedFile
                case decodeByName content of
                    Left err -> text $ "CSV parse error: " <> fromString err
                    Right (_, v) -> do
                        if V.null v
                            then text "CSV file is empty."
                            else do
                                let latest = V.last v

                                    -- Helper to extract lists
                                    extractInts f = V.toList $ V.map f v
                                    extractPairs f1 f2 = V.toList $ V.map (\row -> [f1 row, f2 row]) v
                                    extractDoubles f = V.toList $ V.map f v

                                json $ object
                                    [ "heartRate" .= heartRate latest
                                    , "bloodSugar" .= bloodSugar latest
                                    , "bloodPressureSystolic" .= bloodPressureSystolic latest
                                    , "bloodPressureDiastolic" .= bloodPressureDiastolic latest
                                    , "weight" .= weight latest
                                    , "heartRateHistory" .= extractInts heartRate
                                    , "bloodSugarHistory" .= extractInts bloodSugar
                                    , "bloodPressureHistory" .= extractPairs bloodPressureSystolic bloodPressureDiastolic
                                    , "weightHistory" .= extractDoubles weight
                                    ]
            Nothing -> text "No file uploaded"
