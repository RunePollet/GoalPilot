//
//  Hill.swift
//  GoalPilot
//
//  Created by Rune Pollet on 07/02/2024.
//

import SwiftUI

extension Landscape {
    /// Holds values describing a hill which can be drawn using 'HillView'.
    struct Hill: Identifiable {
        var id = UUID()
        
        var size: CGSize
        var alignment: Alignment
        var color: Color
        var trees: [Tree]
        var path: @Sendable (_ path: inout Path, _ width: CGFloat, _ height: CGFloat) -> Void
    }
}

extension Landscape.Hill {
    static let first: Self = .init(
        size: CGSize(width: 1.0, height: 122.0/292.0),
        alignment: .bottomLeading,
        color: Color(AssetsCatalog.firstHillColorID),
        trees: [.firstHillLeft, .firstHillRight],
        path: { path, width, height in
            path.move(to: CGPoint(x: 0.92773*width, y: 0.13855*height))
            path.addCurve(to: CGPoint(x: 0.99873*width, y: 0.00007*height), control1: CGPoint(x: 0.95148*width, y: 0.0577*height), control2: CGPoint(x: 0.96909*width, y: -0.00228*height))
            path.addCurve(to: CGPoint(x: width, y: 0.0002*height), control1: CGPoint(x: 0.99915*width, y: 0.0001*height), control2: CGPoint(x: 0.99957*width, y: 0.00015*height))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0, y: 0.90164*height))
            path.addCurve(to: CGPoint(x: 0.48065*width, y: 0.53167*height), control1: CGPoint(x: 0.09511*width, y: 0.67288*height), control2: CGPoint(x: 0.25329*width, y: 0.48162*height))
            path.addCurve(to: CGPoint(x: 0.92773*width, y: 0.13855*height), control1: CGPoint(x: 0.79214*width, y: 0.60023*height), control2: CGPoint(x: 0.87503*width, y: 0.318*height))
            path.closeSubpath()
        }
    )
    
    static let second: Self = .init(
        size: CGSize(width: 260.5/393.0, height: 170.0/292.0),
        alignment: .bottomLeading,
        color: Color(AssetsCatalog.secondHillColorID),
        trees: [],
        path: { path, width, height in
            path.move(to: CGPoint(x: 0.73552*width, y: 0.18753*height))
            path.addCurve(to: CGPoint(x: 0.35632*width, y: 0.00436*height), control1: CGPoint(x: 0.63283*width, y: 0.06509*height), control2: CGPoint(x: 0.48933*width, y: 0.01776*height))
            path.addCurve(to: CGPoint(x: 0, y: 0.03465*height), control1: CGPoint(x: 0.16761*width, y: -0.01465*height), control2: CGPoint(x: 0, y: 0.03465*height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0.99808*width, y: height))
            path.addCurve(to: CGPoint(x: 0.97224*width, y: 0.65294*height), control1: CGPoint(x: 0.99808*width, y: height), control2: CGPoint(x: 0.99376*width, y: 0.75689*height))
            path.addCurve(to: CGPoint(x: 0.73552*width, y: 0.18753*height), control1: CGPoint(x: 0.92673*width, y: 0.43318*height), control2: CGPoint(x: 0.82483*width, y: 0.29403*height))
            path.closeSubpath()
        }
    )
    
    static let third: Self = .init(
        size: CGSize(width: 180.76/393.0, height: 245.93/292.0),
        alignment: .bottomLeading,
        color: Color(AssetsCatalog.thirdHillColorID),
        trees: [],
        path: { path, width, height in
            path.move(to: CGPoint(x: 0.69078*width, y: 0.16628*height))
            path.addCurve(to: CGPoint(x: 0, y: 0.0003*height), control1: CGPoint(x: 0.50282*width, y: 0.04868*height), control2: CGPoint(x: 0, y: 0.0003*height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0.99869*width, y: height))
            path.addCurve(to: CGPoint(x: 0.99243*width, y: 0.80081*height), control1: CGPoint(x: 0.99869*width, y: 0.95689*height), control2: CGPoint(x: 0.99713*width, y: 0.85569*height))
            path.addCurve(to: CGPoint(x: 0.95879*width, y: 0.58943*height), control1: CGPoint(x: 0.98674*width, y: 0.73442*height), control2: CGPoint(x: 0.97646*width, y: 0.66193*height))
            path.addCurve(to: CGPoint(x: 0.69078*width, y: 0.16628*height), control1: CGPoint(x: 0.91862*width, y: 0.42465*height), control2: CGPoint(x: 0.84025*width, y: 0.2598*height))
            path.closeSubpath()
        }
    )
    
    static let fourth: Self = .init(
        size: CGSize(width: 180.34/393.0, height: 103.93/292.0),
        alignment: .bottomTrailing,
        color: Color(AssetsCatalog.fourthHillColorID),
        trees: [.fourthHill],
        path: { path, width, height in
            path.move(to: CGPoint(x: width, y: 0))
            path.addCurve(to: CGPoint(x: 0.65193*width, y: 0.043*height), control1: CGPoint(x: width, y: 0), control2: CGPoint(x: 0.76361*width, y: 0.0154*height))
            path.addCurve(to: CGPoint(x: 0.43603*width, y: 0.12192*height), control1: CGPoint(x: 0.57881*width, y: 0.06107*height), control2: CGPoint(x: 0.49922*width, y: 0.08668*height))
            path.addCurve(to: CGPoint(x: 0.22652*width, y: 0.28525*height), control1: CGPoint(x: 0.37017*width, y: 0.15866*height), control2: CGPoint(x: 0.29526*width, y: 0.22086*height))
            path.addCurve(to: CGPoint(x: 0.00371*width, y: 0.51856*height), control1: CGPoint(x: 0.10711*width, y: 0.39709*height), control2: CGPoint(x: 0.00628*width, y: 0.51553*height))
            path.addLine(to: CGPoint(x: 0.00365*width, y: 0.51856*height))
            path.addLine(to: CGPoint(x: 0.00365*width, y: 0.99933*height))
            path.addLine(to: CGPoint(x: width, y: 0.99933*height))
            path.addLine(to: CGPoint(x: width, y: 0.65971*height))
            path.addLine(to: CGPoint(x: width, y: 0))
            path.closeSubpath()
        }
    )
    
    static let firstOnboarding: Self = .init(
        size: CGSize(width: 10, height: 191.0/852.0),
        alignment: .bottomLeading,
        color: Color(AssetsCatalog.thirdHillColorID),
        trees: Landscape.Tree.firstOnboardingHillTrees,
        path: { path, width, height in
            path.move(to: CGPoint(x: 0.35352*width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0.90003*width, y: height))
            path.addCurve(to: CGPoint(x: 0.85803*width, y: 0.49739*height), control1: CGPoint(x: 0.90003*width, y: 0.9974*height), control2: CGPoint(x: 0.87628*width, y: 0.6053*height))
            path.addCurve(to: CGPoint(x: 0.81351*width, y: 0.44791*height), control1: CGPoint(x: 0.84131*width, y: 0.39846*height), control2: CGPoint(x: 0.83047*width, y: 0.36671*height))
            path.addCurve(to: CGPoint(x: 0.78959*width, y: 0.65104*height), control1: CGPoint(x: 0.80366*width, y: 0.49507*height), control2: CGPoint(x: 0.79968*width, y: 0.63739*height))
            path.addCurve(to: CGPoint(x: 0.76886*width, y: 0.5651*height), control1: CGPoint(x: 0.78135*width, y: 0.6622*height), control2: CGPoint(x: 0.77711*width, y: 0.55712*height))
            path.addCurve(to: CGPoint(x: 0.74723*width, y: 0.70833*height), control1: CGPoint(x: 0.75999*width, y: 0.57367*height), control2: CGPoint(x: 0.75588*width, y: 0.66736*height))
            path.addCurve(to: CGPoint(x: 0.68719*width, y: 0.70833*height), control1: CGPoint(x: 0.72439*width, y: 0.81657*height), control2: CGPoint(x: 0.70917*width, y: 0.87547*height))
            path.addCurve(to: CGPoint(x: 0.66048*width, y: 0.38281*height), control1: CGPoint(x: 0.67581*width, y: 0.62179*height), control2: CGPoint(x: 0.67239*width, y: 0.4307*height))
            path.addCurve(to: CGPoint(x: 0.64267*width, y: 0.38281*height), control1: CGPoint(x: 0.65365*width, y: 0.35538*height), control2: CGPoint(x: 0.64955*width, y: 0.40357*height))
            path.addCurve(to: CGPoint(x: 0.61722*width, y: 0.17969*height), control1: CGPoint(x: 0.63212*width, y: 0.35097*height), control2: CGPoint(x: 0.62766*width, y: 0.22457*height))
            path.addCurve(to: CGPoint(x: 0.583*width, y: 0.17969*height), control1: CGPoint(x: 0.60415*width, y: 0.12345*height), control2: CGPoint(x: 0.59609*width, y: 0.23544*height))
            path.addCurve(to: CGPoint(x: 0.56278*width, y: 0.03646*height), control1: CGPoint(x: 0.57482*width, y: 0.14482*height), control2: CGPoint(x: 0.57097*width, y: 0.07018*height))
            path.addCurve(to: CGPoint(x: 0.53136*width, y: 0.03646*height), control1: CGPoint(x: 0.55075*width, y: -0.01305*height), control2: CGPoint(x: 0.54351*width, y: 0.00138*height))
            path.addCurve(to: CGPoint(x: 0.50515*width, y: 0.17969*height), control1: CGPoint(x: 0.52087*width, y: 0.06673*height), control2: CGPoint(x: 0.51566*width, y: 0.15296*height))
            path.addCurve(to: CGPoint(x: 0.48073*width, y: 0.17969*height), control1: CGPoint(x: 0.49569*width, y: 0.20376*height), control2: CGPoint(x: 0.49019*width, y: 0.15437*height))
            path.addCurve(to: CGPoint(x: 0.44931*width, y: 0.38281*height), control1: CGPoint(x: 0.46797*width, y: 0.21384*height), control2: CGPoint(x: 0.46218*width, y: 0.38511*height))
            path.addCurve(to: CGPoint(x: 0.42997*width, y: 0.30469*height), control1: CGPoint(x: 0.44161*width, y: 0.38144*height), control2: CGPoint(x: 0.43765*width, y: 0.29395*height))
            path.addCurve(to: CGPoint(x: 0.40415*width, y: 0.5651*height), control1: CGPoint(x: 0.41876*width, y: 0.32036*height), control2: CGPoint(x: 0.41396*width, y: 0.4528*height))
            path.addCurve(to: CGPoint(x: 0.38583*width, y: 0.79427*height), control1: CGPoint(x: 0.39683*width, y: 0.64885*height), control2: CGPoint(x: 0.39398*width, y: 0.75402*height))
            path.addCurve(to: CGPoint(x: 0.36942*width, y: 0.79427*height), control1: CGPoint(x: 0.3796*width, y: 0.82504*height), control2: CGPoint(x: 0.37561*width, y: 0.76055*height))
            path.addCurve(to: CGPoint(x: 0.35352*width, y: 0.9974*height), control1: CGPoint(x: 0.36235*width, y: 0.83278*height), control2: CGPoint(x: 0.35352*width, y: 0.9974*height))
            path.closeSubpath()
        }
    )
    
    static let secondOnboarding: Self = .init(
        size: CGSize(width: 10, height: 434.8/852.0),
        alignment: .bottomLeading,
        color: Color(AssetsCatalog.secondHillColorID),
        trees: Landscape.Tree.secondOnboardingHillTrees,
        path: { path, width, height in
            path.move(to: CGPoint(x: 0.01107*width, y: 0.56666*height))
            path.addCurve(to: CGPoint(x: 0, y: 0.50459*height), control1: CGPoint(x: 0.00712*width, y: 0.51838*height), control2: CGPoint(x: 0, y: 0.50459*height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: width, y: 0.50344*height))
            path.addCurve(to: CGPoint(x: 0.98715*width, y: 0.51034*height), control1: CGPoint(x: width, y: 0.50344*height), control2: CGPoint(x: 0.99215*width, y: 0.50543*height))
            path.addCurve(to: CGPoint(x: 0.93678*width, y: 0.65631*height), control1: CGPoint(x: 0.96661*width, y: 0.5305*height), control2: CGPoint(x: 0.9573*width, y: 0.67762*height))
            path.addCurve(to: CGPoint(x: 0.89671*width, y: 0.47126*height), control1: CGPoint(x: 0.91932*width, y: 0.63819*height), control2: CGPoint(x: 0.913*width, y: 0.53083*height))
            path.addCurve(to: CGPoint(x: 0.87343*width, y: 0.39769*height), control1: CGPoint(x: 0.88778*width, y: 0.43861*height), control2: CGPoint(x: 0.88196*width, y: 0.43799*height))
            path.addCurve(to: CGPoint(x: 0.85943*width, y: 0.31494*height), control1: CGPoint(x: 0.86764*width, y: 0.37037*height), control2: CGPoint(x: 0.86561*width, y: 0.33418*height))
            path.addCurve(to: CGPoint(x: 0.83717*width, y: 0.31494*height), control1: CGPoint(x: 0.85121*width, y: 0.28932*height), control2: CGPoint(x: 0.84582*width, y: 0.30667*height))
            path.addCurve(to: CGPoint(x: 0.81338*width, y: 0.36321*height), control1: CGPoint(x: 0.8277*width, y: 0.32399*height), control2: CGPoint(x: 0.82276*width, y: 0.34837*height))
            path.addCurve(to: CGPoint(x: 0.7653*width, y: 0.39769*height), control1: CGPoint(x: 0.79483*width, y: 0.39257*height), control2: CGPoint(x: 0.7835*width, y: 0.3537*height))
            path.addCurve(to: CGPoint(x: 0.74303*width, y: 0.47126*height), control1: CGPoint(x: 0.75635*width, y: 0.41931*height), control2: CGPoint(x: 0.75204*width, y: 0.45197*height))
            path.addCurve(to: CGPoint(x: 0.68414*width, y: 0.43677*height), control1: CGPoint(x: 0.72061*width, y: 0.51928*height), control2: CGPoint(x: 0.70694*width, y: 0.467*height))
            path.addCurve(to: CGPoint(x: 0.66022*width, y: 0.39769*height), control1: CGPoint(x: 0.67475*width, y: 0.42433*height), control2: CGPoint(x: 0.66969*width, y: 0.40381*height))
            path.addCurve(to: CGPoint(x: 0.64407*width, y: 0.39769*height), control1: CGPoint(x: 0.65393*width, y: 0.39363*height), control2: CGPoint(x: 0.65031*width, y: 0.40621*height))
            path.addCurve(to: CGPoint(x: 0.61748*width, y: 0.28965*height), control1: CGPoint(x: 0.63281*width, y: 0.38234*height), control2: CGPoint(x: 0.62847*width, y: 0.31637*height))
            path.addCurve(to: CGPoint(x: 0.5699*width, y: 0.28965*height), control1: CGPoint(x: 0.59954*width, y: 0.24604*height), control2: CGPoint(x: 0.58808*width, y: 0.32423*height))
            path.addCurve(to: CGPoint(x: 0.50604*width, y: 0.03448*height), control1: CGPoint(x: 0.54126*width, y: 0.23515*height), control2: CGPoint(x: 0.53078*width, y: -0.10702*height))
            path.addCurve(to: CGPoint(x: 0.48607*width, y: 0.24137*height), control1: CGPoint(x: 0.49338*width, y: 0.10692*height), control2: CGPoint(x: 0.49859*width, y: 0.16698*height))
            path.addCurve(to: CGPoint(x: 0.44981*width, y: 0.28965*height), control1: CGPoint(x: 0.47411*width, y: 0.31241*height), control2: CGPoint(x: 0.46388*width, y: 0.26564*height))
            path.addCurve(to: CGPoint(x: 0.36751*width, y: 0.50459*height), control1: CGPoint(x: 0.41694*width, y: 0.34577*height), control2: CGPoint(x: 0.40097*width, y: 0.5025*height))
            path.addCurve(to: CGPoint(x: 0.31828*width, y: 0.43677*height), control1: CGPoint(x: 0.34806*width, y: 0.5058*height), control2: CGPoint(x: 0.33639*width, y: 0.3726*height))
            path.addCurve(to: CGPoint(x: 0.302*width, y: 0.53103*height), control1: CGPoint(x: 0.31125*width, y: 0.46169*height), control2: CGPoint(x: 0.30933*width, y: 0.51452*height))
            path.addCurve(to: CGPoint(x: 0.28737*width, y: 0.53103*height), control1: CGPoint(x: 0.29645*width, y: 0.54351*height), control2: CGPoint(x: 0.29302*width, y: 0.52334*height))
            path.addCurve(to: CGPoint(x: 0.26956*width, y: 0.5885*height), control1: CGPoint(x: 0.28007*width, y: 0.54096*height), control2: CGPoint(x: 0.27605*width, y: 0.55676*height))
            path.addCurve(to: CGPoint(x: 0.24908*width, y: 0.74942*height), control1: CGPoint(x: 0.26023*width, y: 0.63405*height), control2: CGPoint(x: 0.25895*width, y: 0.71446*height))
            path.addCurve(to: CGPoint(x: 0.22984*width, y: 0.75747*height), control1: CGPoint(x: 0.24004*width, y: 0.78143*height), control2: CGPoint(x: 0.23893*width, y: 0.72387*height))
            path.addCurve(to: CGPoint(x: 0.21916*width, y: 0.78851*height), control1: CGPoint(x: 0.22704*width, y: 0.76782*height), control2: CGPoint(x: 0.22259*width, y: 0.78197*height))
            path.addLine(to: CGPoint(x: 0.21896*width, y: 0.78887*height))
            path.addCurve(to: CGPoint(x: 0.21292*width, y: 0.8046*height), control1: CGPoint(x: 0.21667*width, y: 0.79323*height), control2: CGPoint(x: 0.2154*width, y: 0.79565*height))
            path.addCurve(to: CGPoint(x: 0.20074*width, y: 0.84712*height), control1: CGPoint(x: 0.21038*width, y: 0.81379*height), control2: CGPoint(x: 0.20543*width, y: 0.83366*height))
            path.addCurve(to: CGPoint(x: 0.17898*width, y: 0.82643*height), control1: CGPoint(x: 0.1926*width, y: 0.87047*height), control2: CGPoint(x: 0.1874*width, y: 0.83994*height))
            path.addCurve(to: CGPoint(x: 0.15303*width, y: 0.76321*height), control1: CGPoint(x: 0.16865*width, y: 0.80983*height), control2: CGPoint(x: 0.16353*width, y: 0.76133*height))
            path.addCurve(to: CGPoint(x: 0.12899*width, y: 0.82643*height), control1: CGPoint(x: 0.14326*width, y: 0.76497*height), control2: CGPoint(x: 0.13874*width, y: 0.81905*height))
            path.addCurve(to: CGPoint(x: 0.09439*width, y: 0.76321*height), control1: CGPoint(x: 0.11525*width, y: 0.83684*height), control2: CGPoint(x: 0.10812*width, y: 0.75174*height))
            path.addCurve(to: CGPoint(x: 0.08091*width, y: 0.7885*height), control1: CGPoint(x: 0.08903*width, y: 0.76769*height), control2: CGPoint(x: 0.08618*width, y: 0.77917*height))
            path.addCurve(to: CGPoint(x: 0.06997*width, y: 0.80689*height), control1: CGPoint(x: 0.07664*width, y: 0.79604*height), control2: CGPoint(x: 0.07423*width, y: 0.79956*height))
            path.addCurve(to: CGPoint(x: 0.05418*width, y: 0.82299*height), control1: CGPoint(x: 0.06729*width, y: 0.81149*height), control2: CGPoint(x: 0.05813*width, y: 0.82044*height))
            path.addCurve(to: CGPoint(x: 0.0243*width, y: 0.76321*height), control1: CGPoint(x: 0.05024*width, y: 0.82553*height), control2: CGPoint(x: 0.03606*width, y: 0.85185*height))
            path.addCurve(to: CGPoint(x: 0.01107*width, y: 0.56666*height), control1: CGPoint(x: 0.01566*width, y: 0.69816*height), control2: CGPoint(x: 0.01774*width, y: 0.64839*height))
            path.closeSubpath()
        }
    )
    
    static let thirdOnboarding: Self = .init(
        size: CGSize(width: 10, height: 1),
        alignment: .bottomLeading,
        color: Color(AssetsCatalog.firstHillColorID),
        trees: Landscape.Tree.thirdOnboardingHillTrees,
        path: { path, width, height in
            path.move(to: CGPoint(x: 0.66785*width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0.93334*width, y: height))
            path.addCurve(to: CGPoint(x: 0.90701*width, y: 0.60446*height), control1: CGPoint(x: 0.93334*width, y: 0.95305*height), control2: CGPoint(x: 0.9298*width, y: 0.72717*height))
            path.addCurve(to: CGPoint(x: 0.87228*width, y: 0.47887*height), control1: CGPoint(x: 0.8958*width, y: 0.54409*height), control2: CGPoint(x: 0.8868*width, y: 0.52169*height))
            path.addCurve(to: CGPoint(x: 0.82585*width, y: 0.37383*height), control1: CGPoint(x: 0.85526*width, y: 0.4287*height), control2: CGPoint(x: 0.84401*width, y: 0.41453*height))
            path.addCurve(to: CGPoint(x: 0.80806*width, y: 0.30223*height), control1: CGPoint(x: 0.81773*width, y: 0.35563*height), control2: CGPoint(x: 0.8099*width, y: 0.31573*height))
            path.addCurve(to: CGPoint(x: 0.78708*width, y: 0.2412*height), control1: CGPoint(x: 0.80183*width, y: 0.25646*height), control2: CGPoint(x: 0.79089*width, y: 0.2412*height))
            path.addCurve(to: CGPoint(x: 0.75121*width, y: 0.2412*height), control1: CGPoint(x: 0.77613*width, y: 0.2412*height), control2: CGPoint(x: 0.76832*width, y: 0.25924*height))
            path.addCurve(to: CGPoint(x: 0.71674*width, y: 0.19425*height), control1: CGPoint(x: 0.7334*width, y: 0.22242*height), control2: CGPoint(x: 0.72628*width, y: 0.2142*height))
            path.addCurve(to: CGPoint(x: 0.68274*width, y: 0.01878*height), control1: CGPoint(x: 0.69039*width, y: 0.13915*height), control2: CGPoint(x: 0.69944*width, y: 0.05121*height))
            path.addCurve(to: CGPoint(x: 0.66785*width, y: 0), control1: CGPoint(x: 0.67515*width, y: 0.00404*height), control2: CGPoint(x: 0.66785*width, y: 0))
            path.closeSubpath()
        }
    )
}
