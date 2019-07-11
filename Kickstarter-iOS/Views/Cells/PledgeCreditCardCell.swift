import KsApi
import Library
import Prelude
import UIKit

private enum Layout {
  enum ImageView {
    static let width: CGFloat = 64
    static let height: CGFloat = 40
  }

  enum Button {
    static let width: CGFloat = 217
  }
}

final class PledgeCreditCardCell: UICollectionViewCell, ValueCell {
  // MARK: - Properties

  private let adaptableStackView: UIStackView = { UIStackView(frame: .zero) }()
  private let labelsStackView: UIStackView = { UIStackView(frame: .zero) }()
  private let lastFourLabel: UILabel = { UILabel(frame: .zero) }()
  private let expirationDateLabel: UILabel = { UILabel(frame: .zero) }()
  private let imageView: UIImageView = { UIImageView(frame: .zero) }()
  private let rootStackView: UIStackView = { UIStackView(frame: .zero) }()
  private let selectButton: MultiLineButton = {
    MultiLineButton(type: .custom)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  // MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureSubviews()
    self.bindViewModel()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureSubviews() {
    _ = self
      |> \.accessibilityElements .~ self.subviews

    _ = ([self.lastFourLabel, self.expirationDateLabel], self.labelsStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.imageView, self.labelsStackView], self.adaptableStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.adaptableStackView, self.selectButton], self.rootStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = (self.rootStackView, self.contentView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    NSLayoutConstraint.activate([
      self.imageView.widthAnchor.constraint(equalToConstant: Layout.ImageView.width),
      self.selectButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Layout.ImageView.height),
      self.selectButton.widthAnchor.constraint(equalToConstant: Layout.Button.width)
    ])
  }

  // MARK: - Styles

  override func bindStyles() {
    super.bindStyles()

    _ = self
      |> \.backgroundColor .~ .white
      |> roundedStyle(cornerRadius: Styles.grid(1))

    _ = self.selectButton
      |> checkoutSmallBlackButtonStyle
      |> UIButton.lens.title(for: .normal) %~ { _ in Strings.Select() }

    _ = self.selectButton.titleLabel
      ?|> \.font .~ UIFont.ksr_headline()

    _ = self.imageView
      |> \.contentMode .~ .scaleAspectFit

    _ = self.lastFourLabel
      |> checkoutTitleLabelStyle
      |> \.font .~ UIFont.ksr_headline(size: 14)
      |> \.textColor .~ .ksr_soft_black

    _ = self.expirationDateLabel
      |> checkoutTitleLabelStyle
      |> \.font .~ UIFont.ksr_caption1(size: 11)
      |> \.textColor .~ .ksr_text_dark_grey_500

    _ = self.labelsStackView
      |> \.axis .~ .vertical

    _ = self.adaptableStackView
      |> checkoutAdaptableStackViewStyle(
        self.traitCollection.preferredContentSizeCategory.isAccessibilityCategory
    )
      |> \.spacing .~ Styles.grid(1)

    _ = self.rootStackView
      |> checkoutStackViewStyle
      |> \.layoutMargins .~ UIEdgeInsets(all: Styles.grid(2))
  }

  func configureWith(value: GraphUserCreditCard.CreditCard) {
    self.imageView.image = UIImage(named: value.imageName)
    self.lastFourLabel.text = value.lastFour
    self.expirationDateLabel.text = Strings.Credit_card_expiration(expiration_date: value.expirationDate())
  }
}
